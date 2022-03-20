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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b05d86148b5d741f53cdbb8658cd2b6d42b47afea9a69ded9d5b082bd50e1724"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c4b8b4bfa9461256ff2c7218c40916e9513250afb5a1c70707e91abaa9cbf26"
    sha256 cellar: :any_skip_relocation, monterey:       "572f8d61c77b1d01e0f4adbe419b920669a8db46955ac98af684606234b0f01e"
    sha256 cellar: :any_skip_relocation, big_sur:        "5eca26d4afc1bf304562bf71c71b5d39da4d9c4396563bab302d3d726f40e274"
    sha256 cellar: :any_skip_relocation, catalina:       "ffa21879fa0c12be217b84991d27c1cb09ee5a234e3e7e531b788be7f7d5a478"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "630453b5bb5748ed4d8d1d1b8561980f14f75c7b1c65f583594468c61efe86e0"
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
