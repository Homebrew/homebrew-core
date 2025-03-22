class ApachePulsar < Formula
  desc "Cloud-native distributed messaging and streaming platform"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-4.0.3/apache-pulsar-4.0.3-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-4.0.3/apache-pulsar-4.0.3-src.tar.gz"
  sha256 "eb1357de0804a05c678fcc42afbe90f330d41ac9699d7c2e0fcb45ed39c38e9f"
  license "Apache-2.0"
  head "https://github.com/apache/pulsar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fa5b732175c58dddc8b00a9fbd70f49f43aeb513f0403a791562adc54fd5187"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c38f08ecb8f7b732d4a508bf612c688eaf9512411dc70a643571f9f3f45407b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b2236df218511dc8dfd1d17f78929ef155291ae77ee397458d4ec0151cb7ad49"
    sha256 cellar: :any_skip_relocation, sonoma:        "de74a2781e78064f53d4800e5818bdef59f82370d20c0491804cb4c6e21aa0e8"
    sha256 cellar: :any_skip_relocation, ventura:       "6838b226c6476924f1d3f487e9aa1d9dd3312f36476686c2404542eed2803156"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f8cbdd38039d15ac61ac6f1854bc7e04179f33e36027e17d6b30a38891a04e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6b8de267f6d650211a6a1290b80724d678c9d113f2921501c87b9328f4c71a9"
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
