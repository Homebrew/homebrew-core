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

  bottle do
    cellar :any_skip_relocation
    sha256 "e5c9d5a386a83e4e6a9893be6729625902c7eea07ec109fce83b6864a0512bbf" => :catalina
    sha256 "cbe22d6554e50f65e202e8b65d3bd41b1a18793cc6d33316397c062dd3ddcd79" => :mojave
    sha256 "7efd7e625d8eeb59c6d8ac3c4a582b77024c7f64f46809996404bb7fd9f2be5a" => :high_sierra
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
