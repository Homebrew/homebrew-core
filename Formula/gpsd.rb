class Gpsd < Formula
  desc "Global Positioning System (GPS) daemon"
  homepage "http://catb.org/gpsd/"
  url "https://download.savannah.gnu.org/releases/gpsd/gpsd-3.21.tar.xz"
  mirror "https://download-mirror.savannah.gnu.org/releases/gpsd/gpsd-3.21.tar.xz"
  sha256 "5512a7d3c2e86be83c5555652e5b4cc9049e8878a4320be7f039eb1a7203e5f0"

  bottle do
    cellar :any
    sha256 "e73790ec49d1c4f079e0584596d2126447422c3f569281eb092afc77ece1bc3a" => :catalina
    sha256 "cf9997d1456a9ec3fa49fee4cbc189af1a60cbeb0afb1abfb59c75ede967864c" => :mojave
    sha256 "0e4110bedb2dd77d37e116fc32f1c45775f387df1a3eb21fc870f0a86ce04262" => :high_sierra
  end

  depends_on "scons" => :build

  def install
    system "scons", "chrpath=False", "python=False", "strip=False", "prefix=#{prefix}/"
    system "scons", "install"
  end

  def caveats
    <<~EOS
      gpsd does not automatically detect GPS device addresses. Once started, you
      need to force it to connect to your GPS:

        GPSD_SOCKET="#{var}/gpsd.sock" #{sbin}/gpsdctl add /dev/tty.usbserial-XYZ
    EOS
  end

  plist_options manual: "#{HOMEBREW_PREFIX}/sbin/gpsd -N -F #{HOMEBREW_PREFIX}/var/gpsd.sock /dev/tty.usbserial-XYZ"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/gpsd</string>
          <string>-N</string>
          <string>-F</string>
          <string>#{var}/gpsd.sock</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/gpsd.log</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/gpsd.log</string>
      </dict>
      </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/gpsd -V")
  end
end
