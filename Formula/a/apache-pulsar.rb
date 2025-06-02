class ApachePulsar < Formula
  desc "Cloud-native distributed messaging and streaming platform"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-4.0.5/apache-pulsar-4.0.5-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-4.0.5/apache-pulsar-4.0.5-src.tar.gz"
  sha256 "1b4b1c955c30e6402e779d09848fd7efba48336ba7dc0bf9776ef755eec1cfd0"
  license "Apache-2.0"
  head "https://github.com/apache/pulsar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0f18b0a39760074fd3cd0a7e731c826610779350bbb5fe3a4022f850743fb17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "841cf2109308a08bf87f6fbbd6946519b85ec3ec5ab53f75fd0c8ba75a8d6853"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15bfc2dbb4ffe61e77d576a061706031a3d88007c68ac2083ed9aa994ed8a499"
    sha256 cellar: :any_skip_relocation, sonoma:        "d48880acbe1ca81c5ffaeba96f35d57730c1f6ac9b04d20153bb730f7d679255"
    sha256 cellar: :any_skip_relocation, ventura:       "042894c86387c2b63719b0e3c100eb6e30b7de1a5a8b49727eaf8a268a04de1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa85c0facf3f784fa18d6d061f7864e9e609b4b114425afa778285a96c0d60a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf35ef58325b09242ee722a6b77897c92b3a76c4ae7b6279bb93f37581c27858"
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
