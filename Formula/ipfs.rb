class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.io/"
  url "https://github.com/ipfs/go-ipfs.git",
      tag:      "v0.6.0",
      revision: "d6e036a888ba95c15ce243a45c0cacb4a5bb8ee4"
  # license ["Apache-2.0", "MIT"] - pending https://github.com/Homebrew/brew/pull/7953
  license "Apache-2.0"
  revision 1
  head "https://github.com/ipfs/go-ipfs.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0a54783b7614037349b7c378897bd9da2212db9bf43db160a94a5e463dd1ee33" => :catalina
    sha256 "aff43c71a166c388cb8e6ca5a46d8282dd54f8111632f6d8f8f7cd9a910577c5" => :mojave
    sha256 "d7bea0bd153859687ad5f6375a6a6bb95ce8968366342aec0e005500bc2d159e" => :high_sierra
  end

  depends_on "go@1.14" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/ipfs/go-ipfs").install buildpath.children
    cd("src/github.com/ipfs/go-ipfs") { system "make", "install" }
    bin.install "bin/ipfs"

    cd("src/github.com/ipfs/go-ipfs") { bash_completion.install "misc/completion/ipfs-completion.bash" }
  end

  plist_options manual: "ipfs daemon"

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
