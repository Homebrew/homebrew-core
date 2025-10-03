class ApachePulsar < Formula
  desc "Cloud-native distributed messaging and streaming platform"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-4.1.0/apache-pulsar-4.1.0-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-4.1.0/apache-pulsar-4.1.0-src.tar.gz"
  sha256 "6edb381a41adafcc6117c029caadcf606fd88e427796bef7b188f233aee7362a"
  license "Apache-2.0"
  head "https://github.com/apache/pulsar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "257f518d60e0fa2957cfc360d64c538de4351b649e6a11eb7c33bb460f31564a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "432701f412d644f92f65a7788b7c9cd9284df2df66ff8f4f56d4cd17fbe7190f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6372ff073ab7f90bd1278dc7be7e76c49a1588dcc52ffb7a4bdaba3d0ba0836e"
    sha256 cellar: :any_skip_relocation, sonoma:        "46d89b7aae5c4f0aae195d122680033f37a25915d91e8bbff1418b33e0554e1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1a3d4318f390f2e1c3d7b53fc1aa274acb2bf65f400ce56536fe6cc0d4b974d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "140fab15d195c19bcd8a363e8f9ec3c010142cda0e43ea3979999c69321155cd"
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
  end

  def post_install
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

    spawn bin/"pulsar", "standalone", "--zookeeper-dir", "#{testpath}/zk", "--bookkeeper-dir", "#{testpath}/bk"
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
