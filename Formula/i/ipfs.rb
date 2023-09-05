class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.tech/"
  url "https://github.com/ipfs/kubo.git",
      tag:      "v0.22.0",
      revision: "3f884d31557596a5436a56984beea0657f40e649"
  license all_of: [
    "MIT",
    any_of: ["MIT", "Apache-2.0"],
  ]
  head "https://github.com/ipfs/kubo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "567c19cbb2f69bd37bebcabdeb62c5e1a882ebbf7eb5c5806230b988506a3b85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e968758e3fbcef55d4d674af6b2ff8b25a174ea59c48257d7d6c4d05fb5c4716"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba1c98c26d8fc76f56d9bb285c42ff63a95cccda5f3dbab4a77d1d60a8d1bf4c"
    sha256 cellar: :any_skip_relocation, ventura:        "494b7b74737e9b5fdd9724e3570ee4c34dd7d62fd7ae0b7793456c453ba78e10"
    sha256 cellar: :any_skip_relocation, monterey:       "638766719df29d6b3fbe640d3750300eb68e727d000863f7b7f388bd3c132adf"
    sha256 cellar: :any_skip_relocation, big_sur:        "4bfb9c842e304f23eeafa07f4f32a1e30656eb37c4f2616d84f73dad3b044990"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15e6c3e55e04f3569e117de6aaff082f2470bbe79fe95e8349b587c5a96bfa96"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "cmd/ipfs/ipfs"

    generate_completions_from_executable(bin/"ipfs", "commands", "completion", shells: [:bash])
  end

  service do
    run [opt_bin/"ipfs", "daemon"]
  end

  test do
    assert_match "initializing IPFS node", shell_output(bin/"ipfs init")
  end
end
