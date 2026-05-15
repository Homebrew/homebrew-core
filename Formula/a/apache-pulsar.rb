class ApachePulsar < Formula
  desc "Cloud-native distributed messaging and streaming platform"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-4.2.1/apache-pulsar-4.2.1-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-4.2.1/apache-pulsar-4.2.1-src.tar.gz"
  sha256 "48a700fd8ed2eddfb22d86df47a1c07e9000a0ebd7f6b9f6e1f475c18d9afb11"
  license "Apache-2.0"
  head "https://github.com/apache/pulsar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51433d892f17d51402d8cf9fb109d46f6a3e9ad50cac3b4c4ad6090e9061f364"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "603c72a3d9ea638d738bd55d6d1c719e367ce2f2547412123a4890b27d1bdee2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc484a8df7ccdf212b86253a5c359ed0c10340d70c217418081ae5a305a02a97"
    sha256 cellar: :any_skip_relocation, sonoma:        "8771d7946c1f656c20b93759d929e3535a8f53ff1c56fe32cf099505f9f63cdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0c4d1cc3ceb21971e7c62ab63058c8393dafca0b2e78a24d06d1802a59cb8c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3256f69a86f74687c12477b183da3d53c37ce371cd96868d0aab631aed22566d"
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

    spawn bin/"pulsar", "standalone", "--zookeeper-dir", testpath/"zk", "--bookkeeper-dir", testpath/"bk"
    # The daemon takes some time to start; pulsar-client will retry until it gets a connection, but emit confusing
    # errors until that happens, so sleep to reduce log spam.
    sleep 30
    sleep 30 if OS.mac? && Hardware::CPU.intel?

    output = shell_output("#{bin}/pulsar-client produce my-topic --messages 'hello-pulsar'")
    assert_match "1 messages successfully produced", output
    output = shell_output("#{bin}/pulsar initialize-cluster-metadata -c a -cs localhost -uw localhost -zk localhost")
    assert_match "Cluster metadata for 'a' setup correctly", output
  end
end
