class ApachePulsar < Formula
  desc "Cloud-native distributed messaging and streaming platform"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=pulsar/pulsar-2.10.0/apache-pulsar-2.10.0-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.10.0/apache-pulsar-2.10.0-src.tar.gz"
  sha256 "fadf27077c5a15852791bea45f34191de1edc25799ecd6e2730a9ff656789c0b"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/pulsar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "b61433976259e2444feb34d73eb9c27836f48685ebf752ef67276c9651e3c864"
    sha256 cellar: :any_skip_relocation, big_sur:      "f6ec2467bced9b6cdd2825833973deb9694bff52dc135281e046c2a77e42b86e"
    sha256 cellar: :any_skip_relocation, catalina:     "3cb78902f53b44a9e8736e691261f8cf8a78316643b284731a226d84d080a08a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "81ab3011d5e99d117d290c4a1e50192f2f37ae40ee79b5e78ea8ff8fe6b3b302"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cppunit" => :build
  depends_on "libtool" => :build
  depends_on "maven" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf" => :build
  depends_on arch: :x86_64
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
    libexec.install "#{binpfx}/bin", "#{binpfx}/lib", "#{binpfx}/instances", "#{binpfx}/conf"
    (libexec/"lib/presto/bin/procname/Linux-ppc64le").rmtree
    pkgshare.install "#{binpfx}/examples", "#{binpfx}/licenses"
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
