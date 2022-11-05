class CassandraAT22 < Formula
  desc "Eventually consistent, distributed key-value db"
  homepage "https://cassandra.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=cassandra/2.2.19/apache-cassandra-2.2.19-bin.tar.gz"
  mirror "https://archive.apache.org/dist/cassandra/2.2.19/apache-cassandra-2.2.19-bin.tar.gz"
  sha256 "5496c0254a66b6d50bde7999d1bab9129b0406b71ad3318558f4d7dbfbed0ab9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "5974043dab4a42016e29a066ec3350be4dd797129b63c3ef5e5037e316b015d8"
    sha256 cellar: :any_skip_relocation, catalina: "3e083c6e07585547684fa42039189bebe5b5c2f03044f21f984477a2286a6eeb"
    sha256 cellar: :any_skip_relocation, mojave:   "95c54bb74536958101d4c7c8d659a68d65495c12ea454d98216f782ec58f9e9d"
  end

  keg_only :versioned_formula

  # Original deprecation date: 2022-03-01
  disable! date: "2022-11-04", because: :unsupported

  depends_on "cython" => :build
  depends_on arch: :x86_64 # openjdk@8 is not supported on ARM
  depends_on :macos # Due to Python 2 (does not support Python 3)
  depends_on "openjdk@8"

  # Only >=Yosemite has new enough setuptools for successful compile of the below deps.
  # Python 2 needs setuptools < 45.0.0 (https://github.com/pypa/setuptools/issues/2094)
  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/b2/40/4e00501c204b457f10fe410da0c97537214b2265247bc9a5bc6edd55b9e4/setuptools-44.1.1.zip"
    sha256 "c67aa55db532a0dadc4d2e20ba9961cbd3ccc84d544e9029699822542b5a476b"
  end

  resource "futures" do
    url "https://files.pythonhosted.org/packages/47/04/5fc6c74ad114032cd2c544c575bffc17582295e9cd6a851d6026ab4b2c00/futures-3.3.0.tar.gz"
    sha256 "7e033af76a5e35f58e56da7a91e687706faf4e7bdfb2cbc3f2cca6b9bcda9794"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "thrift" do
    url "https://files.pythonhosted.org/packages/ae/58/35e3f0cd290039ff862c2c9d8ae8a76896665d70343d833bdc2f748b8e55/thrift-0.9.3.tar.gz"
    sha256 "dfbc3d3bd19d396718dab05abaf46d93ae8005e2df798ef02e32793cd963877e"
  end

  resource "cql" do
    url "https://files.pythonhosted.org/packages/0b/15/523f6008d32f05dd3c6a2e7c2f21505f0a785b6dc8949cad325306858afc/cql-1.4.0.tar.gz"
    sha256 "7857c16d8aab7b736ab677d1016ef8513dedb64097214ad3a50a6c550cb7d6e0"
  end

  resource "cassandra-driver" do
    url "https://files.pythonhosted.org/packages/cd/22/7bf65cfd5d60f3c916ed57c88705803fac30928696f2a300d9ee3751b390/cassandra-driver-3.24.0.tar.gz"
    sha256 "83ec8d9a5827ee44bb1c0601a63696a8a9086beaf0151c8255556299246081bd"
  end

  def install
    (var+"lib/cassandra").mkpath
    (var+"log/cassandra").mkpath

    pypath = libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", pypath
    %w[setuptools thrift futures six cql cassandra-driver].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    inreplace "conf/cassandra.yaml", "/var/lib/cassandra", "#{var}/lib/cassandra"
    inreplace "conf/cassandra-env.sh", "/lib/", "/"

    inreplace "bin/cassandra", "-Dcassandra.logdir\=$CASSANDRA_HOME/logs",
                               "-Dcassandra.logdir\=#{var}/log/cassandra"
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
      s.gsub! "cassandra_storagedir\=\"$CASSANDRA_HOME/data\"",
              "cassandra_storagedir\=\"#{var}/lib/cassandra\""

      s.gsub! "#JAVA_HOME=/usr/local/jdk6",
              "JAVA_HOME=#{Language::Java.overridable_java_home_env("1.8")[:JAVA_HOME]}"
    end

    rm Dir["bin/*.bat", "bin/*.ps1"]

    # This breaks on `brew uninstall cassandra && brew install cassandra`
    # https://github.com/Homebrew/homebrew/pull/38309
    (etc+"cassandra").install Dir["conf/*"]

    libexec.install Dir["*.txt", "{bin,interface,javadoc,pylib,lib/licenses}"]
    libexec.install Dir["lib/*.jar"]

    share.install [libexec+"bin/cassandra.in.sh", libexec+"bin/stop-server"]
    inreplace Dir[
      "#{libexec}/bin/cassandra*",
      "#{libexec}/bin/debug-cql",
      "#{libexec}/bin/nodetool",
      "#{libexec}/bin/sstable*"
    ], %r{`dirname "?\$0"?`/cassandra.in.sh},
       "#{share}/cassandra.in.sh"

    bin.write_exec_script Dir["#{libexec}/bin/*"]
    rm bin/"cqlsh" # Remove existing exec script
    (bin/"cqlsh").write_env_script libexec/"bin/cqlsh", PYTHONPATH: pypath
  end

  plist_options manual: "#{HOMEBREW_PREFIX}/opt/cassandra@2.2/bin/cassandra -f"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <true/>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
              <string>#{opt_bin}/cassandra</string>
              <string>-f</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}/lib/cassandra</string>
        </dict>
      </plist>
    EOS
  end

  test do
    system "#{bin}/cassandra", "-v"
  end
end
