class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.io/"
  url "https://github.com/ipfs/go-ipfs.git",
      :tag      => "v0.6.0",
      :revision => "d6e036a888ba95c15ce243a45c0cacb4a5bb8ee4"
  head "https://github.com/ipfs/go-ipfs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4bad7cf9e44d11bc9655372e4111f6f970573ee1c8749e8e5b91f8593a04ca72" => :catalina
    sha256 "15de80c721cf792be672286a5b6c8d595b1ff819ab766ffb0d7d990362bc71b1" => :mojave
    sha256 "dc532bcea6e47264a17338988275c53d973796cff4ea4e083756177ed102086b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/ipfs/go-ipfs").install buildpath.children
    cd("src/github.com/ipfs/go-ipfs") { system "make", "install" }
    bin.install "bin/ipfs"

    cd("src/github.com/ipfs/go-ipfs") { bash_completion.install "misc/completion/ipfs-completion.bash" }
  end

  plist_options :manual => "ipfs daemon"

  def plist
    <<~EOS
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
