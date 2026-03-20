class ApachePulsar < Formula
  desc "Cloud-native distributed messaging and streaming platform"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-4.1.3/apache-pulsar-4.1.3-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-4.1.3/apache-pulsar-4.1.3-src.tar.gz"
  sha256 "367307accfd5f95e9dc3c5939f362b2a5f5996372a7ca4009320ee0abbbe7d0d"
  license "Apache-2.0"
  head "https://github.com/apache/pulsar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1a33d93802cdbbbf4bb27971edfcb6ad2d4ca4f8f010f00040b0bd6401d183d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "488bf0ede4d8140eafbd264d423a4874d4c42f155e67268530bfe7d62253f3fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b472c79d5ff25b9133c95e873a096721e7940ff8ebd04e193d9ef6b8b6ea040"
    sha256 cellar: :any_skip_relocation, sonoma:        "4041aeed452b2e2bf410a850199037a32b96150378e21553ac5d86cebb5b4004"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c3aaa63c29eeb090f400a7f33d9517edcea5753527ec9e2270942dd35b2d6ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8eb29f460bb5935e502f3954e3bb7c4bf5e713b129ab31907155cfc1e6c4dc4"
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
      system "mvn", "clean", "package", "-DskipTests", "-Pcore-modules"
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
