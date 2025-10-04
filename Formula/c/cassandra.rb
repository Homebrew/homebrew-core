class Cassandra < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Eventually consistent, distributed key-value store"
  homepage "https://cassandra.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=cassandra/5.0.5/apache-cassandra-5.0.5-bin.tar.gz"
  mirror "https://archive.apache.org/dist/cassandra/5.0.5/apache-cassandra-5.0.5-bin.tar.gz"
  sha256 "17097f52fe9627a45867efefd8eee42d5fa4c4cbab6e2a92474aa1d370ea0aca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "19d6a16164dcc94804ae0d5105730a2c4c578ff5fd1d37a17ef48a4bc6992213"
    sha256 cellar: :any,                 arm64_sequoia: "eb036975c40eed782b928df11ef9c9ecd6d6693066268b638f01a1388b2b8369"
    sha256 cellar: :any,                 arm64_sonoma:  "bc605977a7081e5c8aa9faf1e278a526967dfe73d7d866d7bf9146e9d40041c3"
    sha256 cellar: :any,                 arm64_ventura: "5969c2671a3f611604a13a7046c39bd5e8965e71fc89b8c733eefb81a729ddf7"
    sha256 cellar: :any,                 sonoma:        "8fc70f3b660464b617f46a8f88d123e2c936239d5528879391401ace1eb4c22a"
    sha256 cellar: :any,                 ventura:       "96e93bb6f6f3d5b0273bc2cb17cfe79a90a96e21215d04c30ade747af2c12076"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0441fa80015c331c066fb500c6da856241b80e86b8fd4cfe8955fa970e5559f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a72513063f3d1f377fd41429a9ae8369eb31120fef4e50df39b1236b4f8f562"
  end

  depends_on "libev"
  depends_on "openjdk@17"
  depends_on "python@3.11" # required 3.8-3.11, https://github.com/apache/cassandra/blob/trunk/bin/cqlsh#L65-L73

  conflicts_with "emqx", because: "both install `nodetool` binaries"

  resource "cassandra-driver" do
    url "https://files.pythonhosted.org/packages/b2/6f/d25121afaa2ea0741d05d2e9921a7ca9b4ce71634b16a8aaee21bd7af818/cassandra-driver-3.29.2.tar.gz"
    sha256 "c4310a7d0457f51a63fb019d8ef501588c491141362b53097fbc62fa06559b7c"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "geomet" do
    url "https://files.pythonhosted.org/packages/cf/21/58251b3de99e0b5ba649ff511f7f9e8399c3059dd52a643774106e929afa/geomet-0.2.1.post1.tar.gz"
    sha256 "91d754f7c298cbfcabd3befdb69c641c27fe75e808b27aa55028605761d17e95"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
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
