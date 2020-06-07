class Asimov < Formula
  desc "Automatically exclude development dependencies from Time Machine backups"
  homepage "https://github.com/stevegrunwell/asimov"
  url "https://github.com/stevegrunwell/asimov/archive/v0.2.0.tar.gz"
  sha256 "2efb456975af066a17f928787062522de06c14eb322b2d133a8bc3a764cc5376"
  head "https://github.com/stevegrunwell/asimov.git", :branch => "develop"

  bottle :unneeded

  def install
    bin.install buildpath/"asimov"
  end

  plist_options :startup => true, :manual => "asimov"

  # Asimov will run in the background on a daily basis
  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
          <dict>
              <key>Label</key>
              <string>#{plist_name}</string>
              <key>Program</key>
              <string>#{opt_bin}/asimov</string>
              <key>StartInterval</key>
              <!-- 24 hours = 60 * 60 * 24 -->
              <integer>86400</integer>
          </dict>
      </plist>
    EOS
  end

  test do
    assert_match %r{Finding node_modules/ directories with corresponding ../package.json files...},
                 shell_output("#{bin}/asimov")
  end
end
