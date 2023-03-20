class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.tech/"
  url "https://github.com/ipfs/kubo.git",
      tag:      "v0.18.1",
      revision: "675f8bddc18baf473f728af5ea8701cb79f97854"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fcbad31c879fdec667936a4554dcca91c691d66e44b9661f357a0809a00e6398"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "928391df10977e6fc904376b75a9af4eab747ee8bbd9a88fe3a0a018ae399df0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e90e63800fee90e649eaabcb0c303629af268d466106323feed7eaf85ebf2703"
    sha256 cellar: :any_skip_relocation, ventura:        "aa4c5193277f7c900d647020acc15a18f9329330369cf8171867581708755f4d"
    sha256 cellar: :any_skip_relocation, monterey:       "b164663b8126c003b6e77a1cd981996067e0af3cc0bf6a96ed6a69650144b80a"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a45563a05f0ec8250036e80069be098afd65f0cc4eacaa2c016150456ce127c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a595cddf7450bf86035d486f7221f52a60c0698143238f3388fca5fa3b5ca17"
  end

  # Support for go 1.20 is merged upstream but not yet landed in a tag:
  # https://github.com/ipfs/kubo/pull/9647
  # Remove on next release.
  depends_on "go@1.19" => :build

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
