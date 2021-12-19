class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.io/"
  url "https://github.com/ipfs/go-ipfs.git",
      tag:      "v0.11.0",
      revision: "67220edaaef4a938fe5fba85d793bfee59db3256"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2ff080a3e25cc5f6ad62948039dbaaaebe1be58cf553de6ea1989d69a8a2241"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bf45662b9350f70b706bd22e8018a3975d16b3aec29b97b07c02990ef24d953"
    sha256 cellar: :any_skip_relocation, monterey:       "3ff1a3d219552f778912f08ad791800d43b2600f0e39a8b0a966db48b8c67069"
    sha256 cellar: :any_skip_relocation, big_sur:        "241568d148a8a0b4701820b8ce11a186fc7d6302174f3cbc27d69961f7e2d634"
    sha256 cellar: :any_skip_relocation, catalina:       "03a432f02fe5b35016e839733c6669612a5555b3af20a8e9c5f5da1b46bc9d64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "778cd577024337b5f730272c5a8a06b9640050514cd6d4ed333d29436851acbc"
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
