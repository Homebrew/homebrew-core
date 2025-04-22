class ApachePulsar < Formula
  desc "Cloud-native distributed messaging and streaming platform"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-4.0.4/apache-pulsar-4.0.4-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-4.0.4/apache-pulsar-4.0.4-src.tar.gz"
  sha256 "9afe7736d3678d2e22bb44b46b1a47ee5e880bb7025f3e84f2df3d448688e15d"
  license "Apache-2.0"
  head "https://github.com/apache/pulsar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3f52208fa1f971e4cfa8e1f3205855a2dfcc469339188291953d56342db5e75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "debaf2c0836910ae3c968f8084b0c55eb33340ed31bb3896a7ffbb46d3ccb5ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a9ff2aa1f00d0a8aca6ada7eebd19704dd3e2f120aaa7bf4d6912a891359ce2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9c5f80fff77e2a799ef8bdd6a804c8faf228f3202e5841034bd1f5a0c52c30b"
    sha256 cellar: :any_skip_relocation, ventura:       "6582f4eaa59efc16c9aee4a031d7e3c45a010100a1be8cb861dcbac95677fdb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f8462e2a26f796400ed76b82b3fc0b6c5ee9b93cb02a16e0e747a2145c697a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81b8430ceec8e7e98023909fd3628b17dbcdaa145bdb19f7ec0dcd72ef9f645d"
  end

  depends_on "maven" => :build
  depends_on "protoc-gen-grpc-java" => :build
  depends_on "openjdk@21"

  def install
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
