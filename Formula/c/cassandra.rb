class Cassandra < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Eventually consistent, distributed key-value store"
  homepage "https://cassandra.apache.org"
  # TODO: Switch to `python@3.13` after https://github.com/apache/cassandra/pull/4628
  url "https://www.apache.org/dyn/closer.lua?path=cassandra/5.0.8/apache-cassandra-5.0.8-bin.tar.gz"
  mirror "https://archive.apache.org/dist/cassandra/5.0.8/apache-cassandra-5.0.8-bin.tar.gz"
  sha256 "1579d7d3f2d812741a28cd2c2cbe29e83541bb4d25fb21ec2c00c1e4fb3b9a8f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bfc15cd9d3db17f3e089661c454a51bb8bbc32cb2798d4464876c5952496a47e"
    sha256 cellar: :any,                 arm64_sequoia: "180a63e5ab13dd22aaa55c5654a36ee5771a20f4b2265a0abe9f3c7e9ffea1b3"
    sha256 cellar: :any,                 arm64_sonoma:  "0d26ad45cdbd0b9ec88140e0339a3d34e82549cd74537b8e4ccdf1f67d942aea"
    sha256 cellar: :any,                 sonoma:        "7908dbaed8ac61780a35650ffb9d4b2d09bf37dabed214495c8bcd5c0f753fc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e31b3645edc4d63c9aa0190827b809b02d8b033edb29d6217951b058518e981c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1330aa5402dd4782daa30d206ceb4b2dfc97e080952db83cb58d168fb2d011e8"
  end

  depends_on "libev"
  depends_on "openjdk@17"
  depends_on "python@3.11" # required 3.8-3.11, https://github.com/apache/cassandra/blob/trunk/bin/cqlsh#L65-L73

  conflicts_with "emqx", because: "both install `nodetool` binaries"

  pypi_packages package_name:   "",
                extra_packages: ["cassandra-driver", "wcwidth"]

  resource "cassandra-driver" do
    url "https://files.pythonhosted.org/packages/06/47/4e0fbdf02a7a418997f16f59feba26937d9973b979d3f23d79fbd8f6186f/cassandra_driver-3.29.3.tar.gz"
    sha256 "ff6b82ee4533f6fd4474d833e693b44b984f58337173ee98ed76bce08721a636"

    # Remove `ez_setup.py` to be compatible with setuptools 82+, remove in next release
    patch do
      url "https://github.com/apache/cassandra-python-driver/commit/7d8015e3c1cff543a5f64c70cff3e14216e58037.patch?full_index=1"
      sha256 "66a5a714aed117306e6c0e78b51615b56ca655e12cb9ea5718b0c1ae384ceef6"
    end
    patch :DATA
  end

  resource "cassandra-driver" do
    url "https://files.pythonhosted.org/packages/06/47/4e0fbdf02a7a418997f16f59feba26937d9973b979d3f23d79fbd8f6186f/cassandra_driver-3.29.3.tar.gz"
    sha256 "ff6b82ee4533f6fd4474d833e693b44b984f58337173ee98ed76bce08721a636"

    # Remove `ez_setup.py` to be compatible with setuptools 82+, remove in next release
    patch do
      url "https://github.com/apache/cassandra-python-driver/commit/7d8015e3c1cff543a5f64c70cff3e14216e58037.patch?full_index=1"
      sha256 "66a5a714aed117306e6c0e78b51615b56ca655e12cb9ea5718b0c1ae384ceef6"
    end
    patch :DATA
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/57/75/31212c6bf2503fdf920d87fee5d7a86a2e3bcf444984126f13d8e4016804/click-8.3.2.tar.gz"
    sha256 "14162b8b3b3550a7d479eafa77dfd3c38d9dc8951f6f69c78913a8f9a7540fd5"
  end

  resource "geomet" do
    url "https://files.pythonhosted.org/packages/2a/8c/dde022aa6747b114f6b14a7392871275dea8867e2bd26cddb80cc6d66620/geomet-1.1.0.tar.gz"
    sha256 "51e92231a0ef6aaa63ac20c443377ba78a303fd2ecd179dc3567de79f3c11605"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/35/a2/8e3becb46433538a38726c948d3399905a4c7cabd0df578ede5dc51f0ec2/wcwidth-0.6.0.tar.gz"
    sha256 "cdc4e4262d6ef9a1a57e018384cbeb1208d8abbc64176027e2c2455c81313159"
  end

  def install
    (var/"lib/cassandra").mkpath
    (var/"log/cassandra").mkpath

    python3 = "python3.11"
    venv = virtualenv_create(libexec/"vendor", python3)
    venv.pip_install resources

    inreplace "conf/cassandra.yaml", "/var/lib/cassandra", var/"lib/cassandra"
    inreplace "conf/cassandra-env.sh", "/lib/", "/"

    inreplace "bin/cassandra", "-Dcassandra.logdir=$CASSANDRA_LOG_DIR",
                               "-Dcassandra.logdir=#{var}/log/cassandra"
    inreplace "bin/cassandra.in.sh" do |s|
      s.gsub! "CASSANDRA_HOME=\"`dirname \"$0\"`/..\"",
              "CASSANDRA_HOME=\"#{libexec}\""
      # Store configs in etc, outside of keg
      s.gsub! "CASSANDRA_CONF=\"$CASSANDRA_HOME/conf\"",
              "CASSANDRA_CONF=\"#{etc}/cassandra\""
      # Jars installed to prefix, no longer in a lib folder
      s.gsub! "\"$CASSANDRA_HOME\"/lib/*.jar",
              "\"$CASSANDRA_HOME\"/*.jar"
      # The jammm Java agent is not in a lib/ subdir either:
      s.gsub! "JAVA_AGENT=\"$JAVA_AGENT -javaagent:$CASSANDRA_HOME/lib/jamm-",
              "JAVA_AGENT=\"$JAVA_AGENT -javaagent:$CASSANDRA_HOME/jamm-"
      # Storage path
      s.gsub! "cassandra_storagedir=\"$CASSANDRA_HOME/data\"",
              "cassandra_storagedir=\"#{var}/lib/cassandra\""

      s.gsub! "#JAVA_HOME=/usr/local/jdk6",
              "JAVA_HOME=#{Language::Java.overridable_java_home_env("17")[:JAVA_HOME]}"
    end

    rm Dir["bin/*.bat", "bin/*.ps1"]

    # This breaks on `brew uninstall cassandra && brew install cassandra`
    # https://github.com/Homebrew/homebrew/pull/38309
    pkgetc.install Dir["conf/*"]

    libexec.install Dir["*.txt", "{bin,interface,javadoc,pylib,lib/licenses}"]
    libexec.install Dir["lib/*.jar"]

    pkgshare.install [libexec/"bin/cassandra.in.sh", libexec/"bin/stop-server"]
    inreplace Dir[
      libexec/"bin/cassandra*",
      libexec/"bin/debug-cql",
      libexec/"bin/nodetool",
      libexec/"bin/sstable*",
    ], %r{`dirname "?\$0"?`/cassandra.in.sh},
       pkgshare/"cassandra.in.sh"

    # Make sure tools are installed
    rm Dir[buildpath/"tools/bin/*.bat"] # Delete before install to avoid copying useless files
    (libexec/"tools").install Dir[buildpath/"tools/lib/*.jar"]

    # Tools use different cassandra.in.sh and should be changed differently
    mv buildpath/"tools/bin/cassandra.in.sh", buildpath/"tools/bin/cassandra-tools.in.sh"
    inreplace buildpath/"tools/bin/cassandra-tools.in.sh" do |s|
      # Tools have slightly different path to CASSANDRA_HOME
      s.gsub! "CASSANDRA_HOME=\"`dirname $0`/../..\"", "CASSANDRA_HOME=\"#{libexec}\""
      # Store configs in etc, outside of keg
      s.gsub! "CASSANDRA_CONF=\"$CASSANDRA_HOME/conf\"", "CASSANDRA_CONF=\"#{etc}/cassandra\""
      # Core Jars installed to prefix, no longer in a lib folder
      s.gsub! "\"$CASSANDRA_HOME\"/lib/*.jar", "\"$CASSANDRA_HOME\"/*.jar"
      # Tools Jars are under tools folder
      s.gsub! "\"$CASSANDRA_HOME\"/tools/lib/*.jar", "\"$CASSANDRA_HOME\"/tools/*.jar"
      # Storage path
      s.gsub! "cassandra_storagedir=\"$CASSANDRA_HOME/data\"", "cassandra_storagedir=\"#{var}/lib/cassandra\""
    end

    pkgshare.install [buildpath/"tools/bin/cassandra-tools.in.sh"]

    # Update tools script files
    inreplace Dir[buildpath/"tools/bin/*"],
              "`dirname \"$0\"`/cassandra.in.sh",
              pkgshare/"cassandra-tools.in.sh"

    venv_bin = libexec/"vendor/bin"
    rw_info = python_shebang_rewrite_info(venv_bin/python3)
    rewrite_shebang rw_info, libexec/"bin/cqlsh.py"

    # Make sure tools are available
    bin.install Dir[buildpath/"tools/bin/*"]
    bin.write_exec_script Dir[libexec/"bin/*"]
    rm bin/"cqlsh"
    (bin/"cqlsh").write_env_script libexec/"bin/cqlsh", PATH: "#{venv_bin}:$PATH"
  end

  service do
    run [opt_bin/"cassandra", "-f"]
    keep_alive true
    working_dir var/"lib/cassandra"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cassandra -v")

    output = shell_output("#{bin}/cqlsh localhost 2>&1", 1)
    assert_match "Connection error", output
  end
end

__END__
diff --git a/setup.py b/setup.py
index ef735b7..891d192 100644
--- a/setup.py
+++ b/setup.py
@@ -16,9 +16,6 @@ import os
 import sys
 import warnings
 
-import ez_setup
-ez_setup.use_setuptools()
-
 from setuptools import setup
 from distutils.command.build_ext import build_ext
 from distutils.core import Extension
