class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.io/"
  url "https://github.com/ipfs/go-ipfs.git",
      tag:      "v0.13.0",
      revision: "c9d51bbe0133968858aa9991b7f69ec269126599"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b096d6f28b2c338b27ae4bc89e2d5d948f70530ec03aef8d623b5162bf3f33c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66a04fee70fd546ed59d1b0889f726e72d307e7cb75485e97e5226fc7b080d3a"
    sha256 cellar: :any_skip_relocation, monterey:       "f40b8ac2e2ff38e4be021c6f220851abf93a0f52be3294230531cafa979a9041"
    sha256 cellar: :any_skip_relocation, big_sur:        "c252151aea93f3d1338a52fe20bef3d7b02489bced42fea4c00e0d6c15b3db0f"
    sha256 cellar: :any_skip_relocation, catalina:       "6101a28948da2d09cdebdfeedabb17ab59e999b3677b327ed95822bed2cc0e9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdd652dd1d3e09ddfc815feaa00039a03468da60739a41957f5c5b073afc5b37"
  end

  depends_on "go" => :build

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
