class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.io/"
  url "https://github.com/ipfs/go-ipfs.git",
      tag:      "v0.9.1",
      revision: "dc2715af68b93611a116b83fca90714e7c5cb50b"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "231298d145992a014cbb51f662441680df8f3770454c72bb6190d8324a78667b"
    sha256 cellar: :any_skip_relocation, big_sur:       "e378ee908d60a07630e6825480c88e4d622131c313a4e12e239f0b19dad4e0ad"
    sha256 cellar: :any_skip_relocation, catalina:      "60c16d40c1350166baf81c50b420504c4cf75af958da803383cc6f7b74b7f1fc"
    sha256 cellar: :any_skip_relocation, mojave:        "567aeeb741ac0e393b848bf01c1015ac471cb0d0049478493a22b2b6dc732006"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a778ad8f01d55f6857cb5e6159584331936ea573a8d3a0586c5637a921c89ba"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "cmd/ipfs/ipfs"

    bash_completion.install "misc/completion/ipfs-completion.bash"
  end

  service do
    run [opt_bin/"ipfs", "daemon"]
  end

  test do
    assert_match "initializing IPFS node", shell_output(bin/"ipfs init")
  end
end
