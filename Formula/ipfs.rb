class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.io/"
  url "https://github.com/ipfs/go-ipfs.git",
      :tag      => "v0.4.20",
      :revision => "8efc82534f74916b3416b7f10e4daac8ff1e95c9"
  head "https://github.com/ipfs/go-ipfs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ded3070262a29b67ae5793665728e998aaa0f3b9be92cc0a5b9a5f020493164a" => :mojave
    sha256 "051958731368a985c9b78fd30c70c0ca1880fe50a24135a49a389b9760de1eef" => :high_sierra
    sha256 "6b6ba9d2f2528a81ef3af055c726df76eca519089f3c0ac57c7375f85beda442" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/ipfs/go-ipfs").install buildpath.children
    cd("src/github.com/ipfs/go-ipfs") { system "make", "install" }
    bin.install "bin/ipfs"
  end

  plist_options :manual => "ipfs daemon"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/ipfs</string>
        <string>daemon</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
  EOS
  end

  test do
    assert_match "initializing IPFS node", shell_output(bin/"ipfs init")
  end
end
