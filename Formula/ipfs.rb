class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.io/"
  url "https://github.com/ipfs/go-ipfs.git",
      :tag      => "v0.4.18",
      :revision => "aefc746f34e5ffdee5fba1915c6603b65a0ebf81"
  head "https://github.com/ipfs/go-ipfs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5afb66ed65cc3feb8d4c05a3b108e41f0b8f10739aeaa53b588aa619e92053e" => :mojave
    sha256 "5b3973c60e1c5bc3f84204941c94110ccdd3ebcfb8c67f25a11f83d1454c3e47" => :high_sierra
    sha256 "6c536497e72cb744d729fb7a9aae9eca170ec491600996637ab44ab793ce4dee" => :sierra
    sha256 "61a83ec128f164cac19cc3ead46edba2b2350b747a3190bee9340f8faaef5cf1" => :el_capitan
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
