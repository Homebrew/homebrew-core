class Kettle < Formula
  desc "Pentaho Data Integration software"
  homepage "https://community.hitachivantara.com/docs/DOC-1009931-downloads"
  url "https://downloads.sourceforge.net/project/pentaho/Pentaho%209.0/client-tools/pdi-ce-9.0.0.0-423.zip"
  sha256 "05adf26c8b51fb14d1ea75e73579a7718d881228f502a4be5d1ce3a27d5c7997"

  bottle :unneeded

  depends_on java: "1.8"

  def install
    rm_rf Dir["*.{bat}"]
    libexec.install Dir["*"]

    (etc+"kettle").install libexec+"pwd/carte-config-master-8080.xml" => "carte-config.xml"
    (etc+"kettle/.kettle").install libexec+"pwd/kettle.pwd"
    (etc+"kettle/simple-jndi").mkpath

    (var+"log/kettle").mkpath

    # We don't assume that carte, kitchen or pan are in anyway unique command names so we'll prepend "pdi"
    env = { BASEDIR: libexec, JAVA_HOME: Language::Java.java_home("1.8") }
    %w[carte kitchen pan].each do |command|
      (bin+"pdi#{command}").write_env_script libexec+"#{command}.sh", env
    end
  end

  plist_options manual: "pdicarte #{HOMEBREW_PREFIX}/etc/kettle/carte-config.xml"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
      "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/pdicarte</string>
            <string>#{etc}/kettle/carte-config.xml</string>
          </array>
          <key>EnvironmentVariables</key>
          <dict>
            <key>KETTLE_HOME</key>
            <string>#{etc}/kettle</string>
          </dict>
          <key>WorkingDirectory</key>
          <string>#{etc}/kettle</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/kettle/carte.log</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/kettle/carte.log</string>
          <key>RunAtLoad</key>
          <true/>
        </dict>
      </plist>
    EOS
  end

  test do
    system "#{bin}/pdipan", "-file=#{libexec}/samples/transformations/Encrypt\ Password.ktr", "-level=RowLevel"
  end
end
