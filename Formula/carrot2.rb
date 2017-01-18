class Carrot2 < Formula
  desc "Search results clustering engine"
  homepage "https://project.carrot2.org"
  url "https://github.com/carrot2/carrot2/releases/download/release%2F3.15.0/carrot2-dcs-3.15.0.zip"
  sha256 "db9c2dad798cdb984b1bec5e68ba8ffab1a5edc820357afddd8eb688c68b34b5"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    libexec.install Dir["*"]
    bin.install libexec/"dcs.sh" => "carrot2"
    inreplace bin/"carrot2", "java", "cd #{libexec} && java"
  end

  plist_options :manual => "carrot2"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>AbandonProcessGroup</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{opt_libexec}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/carrot2</string>
        </array>
      </dict>
    </plist>
    EOS
  end

  test do
    system bin/"carrot2", "--help"
  end
end
