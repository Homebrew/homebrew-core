class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.io/"
  url "https://github.com/ipfs/go-ipfs.git",
      :tag => "v0.4.7",
      :revision => "f76b48dfa08acdda0d89183b8e041757211d2eeb"
  head "https://github.com/ipfs/go-ipfs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5531aa36dbe5b1436f0629c983bb108f7e86f356e722ae43f8ca8a120f6452d2" => :sierra
    sha256 "edf67cb8933d1d2bedc5a46dc39c04e22da9dd94e294fa5f793e3259b103c2ad" => :el_capitan
    sha256 "0b3fbbae12d75cffb5f16a1c3456297888f37b80f395221cd95d9b30cd200564" => :yosemite
  end

  depends_on "go" => :build
  depends_on "godep" => :build
  depends_on "gx"
  depends_on "gx-go"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/ipfs/go-ipfs").install buildpath.children
    cd("src/github.com/ipfs/go-ipfs") { system "make", "install" }
    bin.install "bin/ipfs"
  end

  plist_options :manual => "ipfs"

  def plist; <<-EOS.undent
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
    system bin/"ipfs", "version"
  end
end
