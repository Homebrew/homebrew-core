class Cassandra < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Eventually consistent, distributed key-value store"
  homepage "https://cassandra.apache.org"
  # TODO: Switch to `python@3.13` after https://github.com/apache/cassandra/pull/4628
  # TODO: Switch to `openjdk@21` in 6.0, https://issues.apache.org/jira/browse/CASSANDRA-18831
  url "https://www.apache.org/dyn/closer.lua?path=cassandra/5.0.9/apache-cassandra-5.0.9-bin.tar.gz"
  mirror "https://archive.apache.org/dist/cassandra/5.0.9/apache-cassandra-5.0.9-bin.tar.gz"
  sha256 "eee1460b47ebe188a29521207230617f22aad7f9e1674f5ea454f10c8f344d61"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fc6506e623772e3fed03377295d67a762a8f06ea2f367a4f5f2340ee733b08a1"
    sha256 cellar: :any, arm64_sequoia: "87c32e1cb4284fe2ceeae8073b37a45c5b1beaa72c54df96fa94e70eb5f8de4f"
    sha256 cellar: :any, arm64_sonoma:  "b14ab6675bedfb91ad0f069274b2029390d9b46ec3d825508109aa388a0afbf7"
    sha256 cellar: :any, sonoma:        "7acf413d14903fd907768ac648ed7869ea7608edd8e83a6d10aafbfc371cbd9a"
    sha256 cellar: :any, arm64_linux:   "28fae93d3835491841623e473f8472f63fcd077caeed8f4b5c7227e8243801be"
    sha256 cellar: :any, x86_64_linux:  "a1804debbef69c6daa6a3d7ab3339923a5d22c4c5fd9ccdb78c790fdf71e4571"
  end

  depends_on "libev"
  depends_on "openjdk@17"
  depends_on "python@3.11" # required 3.8-3.11, https://github.com/apache/cassandra/blob/trunk/bin/cqlsh#L65-L73

  conflicts_with "emqx", because: "both install `nodetool` binaries"

  pypi_packages package_name:   "",
                extra_packages: ["cassandra-driver", "wcwidth"]

  resource "cassandra-driver" do
    url "https://files.pythonhosted.org/packages/bb/ed/4e16210e194660f107929ee494f1cf18557252655067d9b39029c241be2d/cassandra_driver-3.30.1.tar.gz"
    sha256 "0c6a3e1428f7c6a9aa6c944b9c47a37cd2cdbeb5b5a82d42c33afdd56f14e398"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/49/85/12f0a49a7c4ffb70572b6c2ef13c90c88fd190debda93b23f026b25f9634/deprecated-1.3.1.tar.gz"
    sha256 "b1b50e0ff0c1fddaa5708a2c6b0a6588bb09b892825ab2b214ac9ea9d92a5223"
  end

  resource "geomet" do
    url "https://files.pythonhosted.org/packages/2a/8c/dde022aa6747b114f6b14a7392871275dea8867e2bd26cddb80cc6d66620/geomet-1.1.0.tar.gz"
    sha256 "51e92231a0ef6aaa63ac20c443377ba78a303fd2ecd179dc3567de79f3c11605"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/34/74/c6428f875774288bec1396f5bfcbc2d925700a4dad61727fd5f2b12f249d/wcwidth-0.8.2.tar.gz"
    sha256 "91fbef97204b96a3d4d421609b80340b760cf33e26da123ff243d76b1fda8dda"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/2b/b0/c1f5a970721f06b85c0cd5142e0ff8fe067708abd779b0c4f4be7d61d09f/wrapt-2.3.0.tar.gz"
    sha256 "681a2d0eefd721998f90642762b8e75c2159ec531b20ad5e437245ea7b06a107"
  end

  def install
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
