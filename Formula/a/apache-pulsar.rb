class ApachePulsar < Formula
  desc "Cloud-native distributed messaging and streaming platform"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=pulsar/pulsar-3.1.2/apache-pulsar-3.1.2-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-3.1.2/apache-pulsar-3.1.2-src.tar.gz"
  sha256 "82270fa4c224af7979d6d4689d7a77742eb3a32a32630e052dc93739a35624e2"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/pulsar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, sonoma:       "84d3eaf420f61cf8d8c1f51dbdc1ad6fcacb1b1631dd22b241ced620b2fa4f91"
    sha256 cellar: :any_skip_relocation, ventura:      "eaca256d0c8f8152e8696142aae0d0aed390adb7ecb7349e2d61c228c38f4f07"
    sha256 cellar: :any_skip_relocation, monterey:     "b01912fe86d28f7c4be6d79134b80d93829ac0e172e9743f4c96ad1d3ddc4028"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3d0a75a7e0c5167a2407a0a20b090eb6859e44374a95ec4c41a468e6627b2a70"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cppunit" => :build
  depends_on "libtool" => :build
  depends_on "maven" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf" => :build
  depends_on arch: :x86_64 # https://github.com/apache/pulsar/issues/16639
  depends_on "openjdk@17"

  def install
    with_env("TMPDIR" => buildpath, **Language::Java.java_home_env("17")) do
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
    libexec.install "#{binpfx}/bin", "#{binpfx}/lib", "#{binpfx}/instances", "#{binpfx}/conf", "#{binpfx}/trino"
    libexec.glob("bin/*.cmd").map(&:unlink)
    rm_r(libexec/"trino/bin/procname/Linux-aarch64")
    rm_r(libexec/"trino/bin/procname/Linux-ppc64le")
    pkgshare.install "#{binpfx}/examples"
    (etc/"pulsar").install_symlink libexec/"conf"

    libexec.glob("bin/*") do |path|
      if !path.fnmatch?("*common.sh") && !path.directory?
        bin_name = path.basename
        (bin/bin_name).write_env_script libexec/"bin"/bin_name, Language::Java.java_home_env("17")
      end
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

    fork do
      exec bin/"pulsar", "standalone", "--zookeeper-dir", "#{testpath}/zk", " --bookkeeper-dir", "#{testpath}/bk"
    end
    # The daemon takes some time to start; pulsar-client will retry until it gets a connection, but emit confusing
    # errors until that happens, so sleep to reduce log spam.
    sleep 30

    output = shell_output("#{bin}/pulsar-client produce my-topic --messages 'hello-pulsar'")
    assert_match "1 messages successfully produced", output
    output = shell_output("#{bin}/pulsar initialize-cluster-metadata -c a -cs localhost -uw localhost -zk localhost")
    assert_match "Cluster metadata for 'a' setup correctly", output
  end
end
