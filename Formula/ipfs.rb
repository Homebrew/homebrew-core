class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.io/"
  url "https://github.com/ipfs/go-ipfs.git",
      :tag => "v0.4.11",
      :revision => "41102bdc4d14f106b14cffe2640dd8981f8b31ef"
  head "https://github.com/ipfs/go-ipfs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "738138bce4f8abedd59b8e54820da081f50a1bc2002672f62d07af25022b1e91" => :high_sierra
    sha256 "8a961d3514db3754454fb470513e128fbfebf04a3e7b2503543a22463b9ec2da" => :sierra
    sha256 "74875243422c9e8ce88d88a208c766ac8776f04d1564608d22decb750aeed009" => :el_capitan
    sha256 "8829d6f75a787249791a1cf64f6f75d2b1d9ee27e60a530880954bef0bd196a5" => :yosemite
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
