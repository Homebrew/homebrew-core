class ApachePulsar < Formula
  desc "Cloud-native distributed messaging and streaming platform"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=pulsar/pulsar-2.9.2/apache-pulsar-2.9.2-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.9.2/apache-pulsar-2.9.2-src.tar.gz"
  sha256 "66cf22136488aabe443d92284fbb3edb15e1b9d8a64cf498b36236f75af29bbc"
  license "Apache-2.0"
  head "https://github.com/apache/pulsar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "e0db8c6b3a3565dbff3778b0ab4e526ee1821e1679c326043502936a4c0304cd"
    sha256 cellar: :any_skip_relocation, big_sur:      "c2cd45e0f5ccd01a5d33e674bd99ee71f9c0cf9a04f9797590a369afbc7605ac"
    sha256 cellar: :any_skip_relocation, catalina:     "c7cffc9c7f31d10d51d15ee6ca515d20c17e9429395ab5288f71d13174c65614"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bb8b8a862e1fe14691c28f40a23c3304346c7e67693f798ff2372818ed165710"
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
