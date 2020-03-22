class Payara < Formula
  desc "Java EE application server forked from GlassFish"
  homepage "https://www.payara.fish"
  url "https://search.maven.org/remotecontent?filepath=fish/payara/distributions/payara/5.192/payara-5.192.zip"
  sha256 "272352a4d8a6fd19a0e3e02bde946fb9a860c1206fc6e39a41279a73f43b2995"

  bottle :unneeded

  depends_on :java => "1.8"

  conflicts_with "glassfish", :because => "both install the same scripts"

  def install
    # Remove Windows scripts
    rm_f Dir["**/*.{bat,exe}"]

    inreplace "bin/asadmin", /AS_INSTALL=.*/,
                             "AS_INSTALL=#{libexec}/glassfish"

    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))
  end

  def caveats
    <<~EOS
      You may want to add the following to your .bash_profile:
        export GLASSFISH_HOME=#{opt_libexec}/glassfish
        export PATH=${PATH}:${GLASSFISH_HOME}/bin
    EOS
  end

  plist_options :manual => "asadmin start-domain --verbose domain1"

  def plist
    <<~EOS
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
    output = shell_output("#{bin}/asadmin list-domains")
    assert_match /^domain1 not running$/, output
    assert_match /^production not running$/, output
    assert_match /^Command list-domains executed successfully\.$/, output
  end
end
