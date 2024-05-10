class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.tech/"
  url "https://github.com/ipfs/kubo.git",
      tag:      "v0.28.0",
      revision: "e7f0f340c65379c1dd2d80967ae625614f1b9eae"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1939f88ec97ede8a33e67dff6d3d690df67364ffba405c2af8023bdd2ab693c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "650d65ce584e52ca16c27a8db054681652de2de7b434b00e077d1850929a2543"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ce36808666f31a02d8e8b438859b530ee5c8f09d5427824e45d6029b7a0c70b"
    sha256 cellar: :any_skip_relocation, sonoma:         "347a0696d92a4956dac1335c839c34e88508e78ea8ab5581a768c61c198b7701"
    sha256 cellar: :any_skip_relocation, ventura:        "351e64b0ac54f1412b92d314b123d22bc604a97a3cbc24d1858c9b90a3f436ac"
    sha256 cellar: :any_skip_relocation, monterey:       "40a18d345f9fa1a270f02905bf718df539261f9b671b21bf1cc4945291b62876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46aad39b37c80f05db69b4192f35f554c22f6375488971fa7f7a78a3d78b3be3"
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
