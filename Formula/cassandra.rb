class Cassandra < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Eventually consistent, distributed key-value store"
  homepage "https://cassandra.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=cassandra/4.1.1/apache-cassandra-4.1.1-bin.tar.gz"
  mirror "https://archive.apache.org/dist/cassandra/4.1.1/apache-cassandra-4.1.1-bin.tar.gz"
  sha256 "7ce3103a76b8af76ffd8488d6bf484e1f175119617f3205ae0526c71d816c6f7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8774eace236b20daa4a56478a405d27f401c7a76989297ffa763355af4816c7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a306be7cd40ec363e835b64898f66cec8e2318602ed702d5e81291134c37e9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e291c7bef0e729eaf18ff845656f79bd66f689c2cc1fef4cae1be47f15e92f1e"
    sha256 cellar: :any_skip_relocation, ventura:        "5ab5ef53c7b9d5ffba3f6d6050fe5a7f57f664d96fc4c21327af3968d57ae393"
    sha256 cellar: :any_skip_relocation, monterey:       "616061b5752e4d9733d3a79fe5f17448d501b8d0603164367753450a85754660"
    sha256 cellar: :any_skip_relocation, big_sur:        "e41419931ed8dc7416b1758f868d55177767c7034c15d5c93ae61766b829ae9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34c371d1340142ab1e52ec01633574c6afc40c64d606f5309463f9684eaa38ef"
  end

  depends_on "libcython" => :build
  depends_on "openjdk@11"
  depends_on "python@3.11"
  depends_on "six"

  resource "thrift" do
    url "https://files.pythonhosted.org/packages/e4/23/dd951c9883cb49a73b750bdfe91e39d78e8a3f1f7175608634f381a197d5/thrift-0.16.0.tar.gz"
    sha256 "2b5b6488fcded21f9d312aa23c9ff6a0195d0f6ae26ddbd5ad9e3e25dfc14408"
  end

  resource "cql" do
    url "https://files.pythonhosted.org/packages/0b/15/523f6008d32f05dd3c6a2e7c2f21505f0a785b6dc8949cad325306858afc/cql-1.4.0.tar.gz"
    sha256 "7857c16d8aab7b736ab677d1016ef8513dedb64097214ad3a50a6c550cb7d6e0"
  end

  resource "cassandra-driver" do
    url "https://files.pythonhosted.org/packages/af/aa/3d3a6dae349d4f9b69d37e6f3f8b8ef286a06005aa312f0a3dc7af0eb556/cassandra-driver-3.25.0.tar.gz"
    sha256 "8ad7d7c090eb1cac6110b3bfc1fd2d334ac62f415aac09350ebb8d241b7aa7ee"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "geomet" do
    url "https://files.pythonhosted.org/packages/be/9c/dc5a874b12bbab2981edf92d7d03b9d37de6261655b57590a166c890b148/geomet-0.3.0.tar.gz"
    sha256 "cb52411978ee01ff104ab48f108d7333b14423ae7a15a65fee25b7d29bda2e1b"
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
              "JAVA_HOME=#{Language::Java.overridable_java_home_env("11")[:JAVA_HOME]}"
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
