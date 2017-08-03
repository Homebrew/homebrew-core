class Payara < Formula
  desc "Java EE application server forked from GlassFish"
  homepage "https://www.payara.fish"
  url "https://search.maven.org/remotecontent?filepath=fish/payara/distributions/payara/4.1.2.172/payara-4.1.2.172.zip"
  sha256 "5ca8e79822cf9a9e7adca84a21ab79acb91b5b86489bcd5c9b34f62ec86dcd4a"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    # Remove Windows scripts
    rm_f Dir["**/*.bat"]
    libexec.install Dir["*"]
  end

  def caveats; <<-EOS.undent
    The GlassFish home of Payara #{version} is:
      #{opt_libexec}/glassfish
    You may want to add the following to your .bash_profile:
      PAYARA_HOME=#{opt_libexec}
      export GLASSFISH_HOME=${PAYARA_HOME}/glassfish
      export PATH=${PATH}:${GLASSFISH_HOME}/bin:${PAYARA_HOME}/bin

    Note: The support scripts used by Payara are *NOT* linked to bin.
  EOS
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/payara/libexec/bin/asadmin start-domain --verbose domain1"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>KeepAlive</key>
      <dict>
        <key>Crashed</key>
        <true/>
        <key>SuccessfulExit</key>
        <false/>
      </dict>
      <key>WorkingDirectory</key>
      <string>#{opt_libexec}/glassfish</string>
      <key>EnvironmentVariables</key>
      <dict>
        <key>GLASSFISH_HOME</key>
        <string>#{opt_libexec}/glassfish</string>
      </dict>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_libexec}/glassfish/bin/asadmin</string>
        <string>start-domain</string>
        <string>--verbose</string>
        <string>domain1</string>
      </array>
    </dict>
    </plist>
  EOS
  end

  test do
    ENV["GLASSFISH_HOME"] = opt_libexec/"glassfish"

    output = shell_output("#{opt_libexec}/glassfish/bin/asadmin list-domains")

    assert_match /^domain1 not running$/, output
    assert_match /^payaradomain not running$/, output
    assert_match /^Command list-domains executed successfully\.$/, output
  end
end
