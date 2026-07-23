class ApachePulsar < Formula
  desc "Cloud-native distributed messaging and streaming platform"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-4.2.3/apache-pulsar-4.2.3-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-4.2.3/apache-pulsar-4.2.3-src.tar.gz"
  sha256 "38cb0653f354fc0192b5d546c070278c87f9c6633e3e9a6ec7f77ff87f86aa36"
  license "Apache-2.0"
  head "https://github.com/apache/pulsar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40d9cfc0f0da4b6ea521847ee4d012cb2b73382f9b0a9e1248052acda9988b34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3874cc695365606b0458a7fd307cf09d91dd58983fda42a8d317afce844c9598"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d775025922f22385933098b89cfd2d11f163e3ae3d8c87e57fe0d367044b5c81"
    sha256 cellar: :any_skip_relocation, sonoma:        "88984227019fbea528344f2e3e768aff88f68bd3bff230a7480e286eaaaec7c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55959180358d69abcf1975e93628efac00aad58c560a29d3aacb113fdc550e47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55bfb107f8889b41a4c93797680cfb58c586b8d8f3b7f927679e2e1640fb889f"
  end

  depends_on "maven" => :build
  depends_on "protoc-gen-grpc-java" => :build
  depends_on "openjdk@21"

  def install
    # Pin gRPC Java version to that of protoc-gen-grpc-java
    inreplace "pom.xml",
              %r{<grpc.version>\d+(?:\.\d+)+</grpc.version>},
              "<grpc.version>#{Formula["protoc-gen-grpc-java"].version}</grpc.version>"

    # Avoid using pre-built `protoc-gen-grpc-java`
    grpc_java_files = ["pulsar-client/pom.xml", "pulsar-functions/proto/pom.xml"]
    plugin_artifact = "io.grpc:protoc-gen-grpc-java:${protoc-gen-grpc-java.version}:exe:${os.detected.classifier}"
    inreplace grpc_java_files, %r{<pluginArtifact>#{Regexp.escape(plugin_artifact)}\s*</pluginArtifact>}, ""

    java_home_env = Language::Java.java_home_env("21")
    with_env(TMPDIR: buildpath, **java_home_env) do
      # Exclude the `docker` module, we don't need the image.
      system "mvn", "clean", "package", "-DskipTests", "-Pcore-modules",
                    "-pl", "!:docker-images,!:pulsar-docker-image,!:pulsar-all-docker-image"
    end

    tarball = if build.head?
      Dir["distribution/server/target/apache-pulsar-*-bin.tar.gz"].first
    else
      "distribution/server/target/apache-pulsar-#{version}-bin.tar.gz"
    end

    libexec.mkpath
    system "tar", "--extract", "--file", tarball, "--directory", libexec, "--strip-components=1"
    pkgshare.install libexec/"examples"
    (etc/"pulsar").install_symlink libexec/"conf"

    rm libexec.glob("bin/*.cmd")
    libexec.glob("bin/*") do |path|
      next if !path.file? || path.fnmatch?("*common.sh")

      (bin/path.basename).write_env_script path, java_home_env
    end

    (var/"log/pulsar").mkpath
  end

  service do
    run [opt_bin/"pulsar", "standalone"]
    log_path var/"log/pulsar/output.log"
    error_log_path var/"log/pulsar/error.log"
  end

  test do
    ENV["PULSAR_GC_LOG"] = "-Xlog:gc*:#{testpath}/pulsar_gc_%p.log:time,uptime:filecount=10,filesize=20M"
    ENV["PULSAR_LOG_DIR"] = testpath
    ENV["PULSAR_STANDALONE_USE_ZOOKEEPER"] = "1"

    pid = spawn bin/"pulsar", "standalone", "--zookeeper-dir", testpath/"zk", "--bookkeeper-dir", testpath/"bk"
    # The daemon takes some time to start; pulsar-client will retry until it gets a connection, but emit confusing
    # errors until that happens, so sleep to reduce log spam.
    sleep 30
    sleep 30 if OS.mac? && Hardware::CPU.intel?

    output = shell_output("#{bin}/pulsar-client produce my-topic --messages 'hello-pulsar'")
    assert_match "1 messages successfully produced", output
    output = shell_output("#{bin}/pulsar initialize-cluster-metadata -c a -cs localhost -uw localhost -zk localhost")
    assert_match "Cluster metadata for 'a' setup correctly", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
