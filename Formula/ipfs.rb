class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.io/"
  url "https://github.com/ipfs/go-ipfs.git",
      tag:      "v0.12.1",
      revision: "da2b9bd71aa5d02203be5a0b67f8a9116e8535f5"
  license all_of: [
    "MIT",
    any_of: ["MIT", "Apache-2.0"],
  ]
  head "https://github.com/ipfs/go-ipfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6bac8e3eb3280b5d04ae114930f7b4db0d7b46771761323e7ab39679ad797f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b71ea44003d1487d954b93eccce4229c54f5f9b42366d90a7cc42aaa0ddea471"
    sha256 cellar: :any_skip_relocation, monterey:       "af8d3e1ffc4e752ffc725be1ab16e54d521da0b44f13ca9babac8c9220a29d5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f68dccc473bb3e29667ed7d8ed6d10272da4551d80e8a34ee2f1ada19012f17"
    sha256 cellar: :any_skip_relocation, catalina:       "0e415f1dbaf97a65ccf1e211307e7e75e59251cc2b8fb82e3df9d7307ca67a53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25043e8f6570aa51aaac1a5205cfcfe82bd6d7f8db828c9dc2caca06c55529f5"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "make", "build"
    bin.install "cmd/ipfs/ipfs"

    bash_output = Utils.safe_popen_read(bin/"ipfs", "commands", "completion", "bash")
    (bash_completion/"ipfs-completion.bash").write bash_output
  end

  service do
    run [opt_bin/"ipfs", "daemon"]
  end

  test do
    assert_match "initializing IPFS node", shell_output(bin/"ipfs init")
  end
end
