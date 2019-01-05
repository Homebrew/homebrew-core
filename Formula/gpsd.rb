class Gpsd < Formula
  desc "Global Positioning System (GPS) daemon"
  homepage "http://catb.org/gpsd/"
  url "https://download.savannah.gnu.org/releases/gpsd/gpsd-3.17.tar.gz"
  sha256 "68e0dbecfb5831997f8b3d6ba48aed812eb465d8c0089420ab68f9ce4d85e77a"

  bottle do
    cellar :any
    sha256 "5eb90753d0b3ff4a585d41fc35d26068092592a14ca271202c3acd1a2deb9525" => :mojave
    sha256 "89237ff11349f301e4a41a9f1d0ad7948f9a257d91a95be6ec6b4c9e26187f72" => :high_sierra
    sha256 "1a7912b32f3cc2d59d5d7b615ec3e8e2d14399d0256f2768b91be029f64e2438" => :sierra
    sha256 "6fb615b0aba85f6692cf6f8ac529ee8a2777d300bba6a9d8ff8abe90784d0fa5" => :el_capitan
  end

  depends_on "scons" => :build

  def install
    scons "chrpath=False", "python=False", "strip=False", "prefix=#{prefix}/"
    scons "install"
  end

  def caveats; <<~EOS
    gpsd does not automatically detect GPS device addresses. Once started, you
    need to force it to connect to your GPS:

      GPSD_SOCKET="#{var}/gpsd.sock" #{sbin}/gpsdctl add /dev/tty.usbserial-XYZ
  EOS
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/sbin/gpsd -N -F #{HOMEBREW_PREFIX}/var/gpsd.sock /dev/tty.usbserial-XYZ"

  def plist; <<~EOS
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
