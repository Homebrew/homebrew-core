class ApachePulsar < Formula
  desc "Cloud-native distributed messaging and streaming platform"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-4.2.2/apache-pulsar-4.2.2-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-4.2.2/apache-pulsar-4.2.2-src.tar.gz"
  sha256 "ac9c1ddc8bccff5f721d245ccc4b466f34cd021587d51c794379ca80fb01de72"
  license "Apache-2.0"
  head "https://github.com/apache/pulsar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6ea74b0b5e00394322f4c30987475f65e0fa3f765913e3e6112ddc9bc8155e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99929cf063855b6e687340052102c2c33e85c64ff1c3557d83f30b72d568f52f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ad8a1371378b8e532bc2168284fb7b07521193b76ed667d63fa3405033b59e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e68ac543688ea3209023af479a60a454e41403b11e0e4a7c2675771aaf20e831"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9db484273309851af1cc98d5757408c88d3a9d31d68bb35d6c319c80d54d67a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cb0d02aa66e83856b537afa5e7313d26761380c051b5e9aeebd8349cb35ad51"
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
