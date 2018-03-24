class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.io/"
  url "https://github.com/ipfs/go-ipfs.git",
      :tag => "v0.4.14",
      :revision => "5db38464bfea73e94cb96e011cf93051fe691e65"
  head "https://github.com/ipfs/go-ipfs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "df19f3a4470facb659a08ae6ac3fe5c9ecaf9a8fd7eee23586e326c73a4c7d6f" => :high_sierra
    sha256 "11842cd3d44b6ab9b0f07fb664d5c9df5ea2cf63f301b39b958bdf3fac97f71c" => :sierra
    sha256 "5598b26f5293b4a12def593467ab5bfd1175cf82890ca6f45e9c28fed33bd3f0" => :el_capitan
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
    system bin/"ipfs", "version"
  end
end
