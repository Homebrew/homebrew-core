class Autokbisw < Formula
  desc "Automatic keyboard/input source switching for OSX"
  homepage "https://github.com/jeantil/autokbisw"
  url "https://github.com/jeantil/autokbisw/archive/1.2.0.tar.gz"
  sha256 "1c3bfad19b9025ad15f01ea0554351f47225807efd85cb4b4f0b6e1785af3f3e"

  depends_on :xcode

  def install
    system "swift", "build", "-c", "release", "-Xswiftc", "-static-stdlib", "--disable-sandbox"
    bin.install ".build/release/autokbisw"
  end

  plist_options :startup => true

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{bin}/autokbisw</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
    </plist>
  EOS
  end

  test do
    system bin/"autokbisw", "--help"
  end
end
