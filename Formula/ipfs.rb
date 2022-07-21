class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.tech/"
  url "https://github.com/ipfs/kubo.git",
      tag:      "v0.14.0",
      revision: "e0fabd6dbf69624a259dd735065465e09ebb0a61"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a68be749f551169e5ff7808f6b8ee91a6e7c6b5558d8e8dd2318236fe8e45976"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac28495163521e0a0126d06f80fa6f2eb8ec7689024d6e02b5a5c8a059e7ad41"
    sha256 cellar: :any_skip_relocation, monterey:       "b02c6d7c9db1d9b53e9897ed83512ab6f106f22dd048c992084e68566414f2fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "59fe2e71a982dc444c375121b22d30faf7bc3968316ae74a77e79eb3bc9d3e54"
    sha256 cellar: :any_skip_relocation, catalina:       "1acdf6e3a2eadc3d4409b66ab67d52c6bfd00d38b930b9d367b7114805465d14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7bdee033cd72bd8432f1fd2db5013cc0f59b9d6de805e2c9944aaa47b1a5490"
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
