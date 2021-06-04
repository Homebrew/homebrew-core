class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.io/"
  url "https://github.com/ipfs/go-ipfs.git",
      tag:      "v0.8.0",
      revision: "ce693d7e81e0206b3afbce30333c21a36a9f094b"
  license all_of: [
    "MIT",
    any_of: ["MIT", "Apache-2.0"],
  ]
  head "https://github.com/ipfs/go-ipfs.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4c9d2c33c2a753caf23f20358fc172d3fef31bcdf137153ef8ae49c8531879d5"
    sha256 cellar: :any_skip_relocation, big_sur:       "3a2bfd272e46d38caebdb996416aff031c885b1c9067105f0f443d44dc2bf651"
    sha256 cellar: :any_skip_relocation, catalina:      "e2377e7a1265d2f7b8d7adec54d8d92abcb0dcaefcdba25522fb533ba11cdb1a"
    sha256 cellar: :any_skip_relocation, mojave:        "282281d17760d795f8acb0371036c8d6c1d7539e1a802cb99772375200e0d9ab"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "cmd/ipfs/ipfs"

    bash_completion.install "misc/completion/ipfs-completion.bash"
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
