class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.io/"
  url "https://github.com/ipfs/go-ipfs.git",
      :tag      => "v0.4.23",
      :revision => "6ce9a355f9757a921d1e30f4a702028d5e4fb7eb"
  revision 1
  head "https://github.com/ipfs/go-ipfs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ecb76dcfe78abf785fa4afff5e2d73e1a98692b7d8f09213547aa9c3f96c367" => :catalina
    sha256 "d3609f786bed42efdd33316a5f12a3ff29cfc0f435576576f80f8a8fc9704893" => :mojave
    sha256 "d7500e7a35b54a95c64618a9539845d398411428989e3e126632d9ffc80577c6" => :high_sierra
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
