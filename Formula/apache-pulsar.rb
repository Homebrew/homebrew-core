class ApachePulsar < Formula
  desc "Cloud-native distributed messaging and streaming platform"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=pulsar/pulsar-2.10.0/apache-pulsar-2.10.0-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.10.0/apache-pulsar-2.10.0-src.tar.gz"
  sha256 "fadf27077c5a15852791bea45f34191de1edc25799ecd6e2730a9ff656789c0b"
  license "Apache-2.0"
  head "https://github.com/apache/pulsar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "957c2fa40cd1b7867dc4463ba65fb613ba3e67b672294ede255d6920881af932"
    sha256 cellar: :any_skip_relocation, big_sur:      "4badd3eebc91259b2e8e0654b66e1a775c56c915529e10ee8bd90ed87d51feb7"
    sha256 cellar: :any_skip_relocation, catalina:     "a1af20becc06d2d7984ba32906a35f12c9ff988fe8c5eff4381027ecf4e72f98"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "72fc6caf2b5ad176ca9345befa61173e13f72fa11bed603b5ce0f757e5aa2f78"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cppunit" => :build
  depends_on "libtool" => :build
  depends_on "maven" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf" => :build
  depends_on arch: :x86_64
  depends_on "openjdk@11"

  def install
    with_env("TMPDIR" => buildpath, **Language::Java.java_home_env("11")) do
      system "mvn", "-X", "clean", "package", "-DskipTests", "-Pcore-modules"
    end

    built_version = if build.head?
      # This script does not need any particular version of py3 nor any libs, so both
      # brew-installed python and system python will work.
      Utils.safe_popen_read("python3", "src/get-project-version.py").strip
    else
      version
    end

    binpfx = "apache-pulsar-#{built_version}"
    system "tar", "-xf", "distribution/server/target/#{binpfx}-bin.tar.gz"
    libexec.install "#{binpfx}/bin", "#{binpfx}/lib", "#{binpfx}/instances", "#{binpfx}/conf"
    (libexec/"lib/presto/bin/procname/Linux-ppc64le").rmtree
    pkgshare.install "#{binpfx}/examples", "#{binpfx}/licenses"
    (etc/"pulsar").install_symlink libexec/"conf"

    libexec.glob("bin/*") do |path|
      if !path.fnmatch?("*common.sh") && !path.directory?
        bin_name = path.basename
        (bin/bin_name).write_env_script libexec/"bin"/bin_name, Language::Java.java_home_env("11")
      end
    end
  end

  def post_install
    (var/"log/pulsar").mkpath
  end

  service do
    run [bin/"pulsar", "standalone"]
    log_path var/"log/pulsar/output.log"
    error_log_path var/"log/pulsar/error.log"
  end

  test do
    ENV["PULSAR_GC_LOG"] = "-Xlog:gc*:#{testpath}/pulsar_gc_%p.log:time,uptime:filecount=10,filesize=20M"
    ENV["PULSAR_LOG_DIR"] = testpath
    fork do
      exec bin/"pulsar", "standalone", "--zookeeper-dir", "#{testpath}/zk", " --bookkeeper-dir", "#{testpath}/bk"
    end
    # The daemon takes some time to start; pulsar-client will retry until it gets a connection, but emit confusing
    # errors until that happens, so sleep to reduce log spam.
    sleep 15

    output = shell_output("#{bin}/pulsar-client produce my-topic --messages 'hello-pulsar'")
    assert_match "1 messages successfully produced", output
    output = shell_output("#{bin}/pulsar initialize-cluster-metadata -c a -cs localhost -uw localhost -zk localhost")
    assert_match "Cluster metadata for 'a' setup correctly", output
  end
end
