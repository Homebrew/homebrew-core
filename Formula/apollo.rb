class Apollo < Formula
  desc "Multi-protocol messaging broker based on ActiveMQ"
  homepage "https://activemq.apache.org/apollo"
  url "https://archive.apache.org/dist/activemq/activemq-apollo/1.7.1/apache-apollo-1.7.1-unix-distro.tar.gz"
  sha256 "74577339a1843995a5128d14c68b21fb8f229d80d8ce1341dd3134f250ab689d"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "48b09eb2c2be0ed37a27b6b4d6835c5db6d80c877ea10e46296ddd17f8e646ba" => :high_sierra
    sha256 "1d4d6ac835aa8f72d8fb3084780e215986737c6609dff27a552730f2df9f5fc7" => :sierra
    sha256 "1521942c30bd7443a79d944c384391cea0944089a0242b89f31c2c2e4dda1e81" => :el_capitan
    sha256 "1521942c30bd7443a79d944c384391cea0944089a0242b89f31c2c2e4dda1e81" => :yosemite
  end

  deprecated_option "no-bdb" => "without-bdb"
  deprecated_option "no-mqtt" => "without-mqtt"

  option "without-bdb", "Install without bdb store support"
  option "without-mqtt", "Install without MQTT protocol support"

  depends_on :java => "1.7+"

  # https://www.oracle.com/technetwork/database/berkeleydb/overview/index-093405.html
  resource "bdb-je" do
    url "https://download.oracle.com/maven/com/sleepycat/je/5.0.34/je-5.0.34.jar"
    sha256 "025afa4954ed4e6f926af6e9015aa109528b0f947fcb3790b7bace639fe558fa"
  end

  # https://github.com/fusesource/fuse-extra/tree/master/fusemq-apollo/fusemq-apollo-mqtt
  resource "mqtt" do
    url "https://search.maven.org/remotecontent?filepath=org/fusesource/fuse-extra/fusemq-apollo-mqtt/1.3/fusemq-apollo-mqtt-1.3-uber.jar"
    sha256 "2795caacbc6086c7de46b588d11a78edbf8272acb7d9da3fb329cb34fcb8783f"
  end

  def install
    prefix.install_metafiles
    prefix.install %w[docs examples]
    libexec.install Dir["*"]

    (libexec/"lib").install resource("bdb-je") if build.with? "bdb"
    (libexec/"lib").install resource("mqtt") if build.with? "mqtt"

    (bin/"apollo").write_env_script libexec/"bin/apollo", Language::Java.java_home_env
  end

  def caveats; <<~EOS
    To create the broker:
        #{bin}/apollo create #{var}/apollo
    EOS
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/var/apollo/bin/apollo-broker run"

  def plist; <<~EOS
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
          <string>#{var}/apollo/bin/apollo-broker</string>
          <string>run</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}/apollo</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system bin/"apollo", "create", testpath
    assert_predicate testpath/"bin/apollo-broker", :exist?
    assert_predicate testpath/"bin/apollo-broker", :executable?
  end
end
