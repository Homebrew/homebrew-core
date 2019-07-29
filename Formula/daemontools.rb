class Daemontools < Formula
  desc "Collection of tools for managing UNIX services"
  homepage "https://cr.yp.to/daemontools.html"
  url "https://cr.yp.to/daemontools/daemontools-0.76.tar.gz"
  sha256 "a55535012b2be7a52dcd9eccabb9a198b13be50d0384143bd3b32b8710df4c1f"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "172b9445882bb8597d6956c6f84905294b4bb67080d126d73d365c46bd6d5c88" => :mojave
    sha256 "29250f6ce1afab2b4ded2fd87257af7cfe6b2f98ff86753d6040b8f76e5a0648" => :high_sierra
    sha256 "6a01bbd2d5ff12ef6ee8b21577b32828646a3a65bcfb99a62580e2017ec30c54" => :sierra
  end

  def install
    cd "daemontools-#{version}" do
      system "package/compile"
      bin.install Dir["command/*"]
    end
  end

  def caveats; <<~EOS
    You must create the /service directory before starting svscan:
      sudo mkdir /service
      sudo brew services start daemontools
  EOS
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
        <string>#{opt_bin}/svscanboot</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
    </dict>
    </plist>
  EOS
  end

  test do
    assert_match /Homebrew/, shell_output("#{bin}/softlimit -t 1 echo 'Homebrew'")
  end
end
