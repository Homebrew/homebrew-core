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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dadc0f2a713eff0b5e09f4f04e1a4d9df52424a7e68486da0d7c6e04a3eb9de7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04533ec754fcd594d81ad6cb4f043931a79b1f7cc9b45446b82f007553bd4552"
    sha256 cellar: :any_skip_relocation, monterey:       "a140c058546116405b4a3fe332d8ca6bb5b144151076e4014f74b460a6df7853"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1d1c69322bb5e2e97295af169f84761343f2b4d0d9122f9094514af8768288e"
    sha256 cellar: :any_skip_relocation, catalina:       "da67e5f83d11678f8c4583ba1ac64bfc210994dfe9c6c8a5b191e5aff4b5596f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edebe83ebb656162416c90f41ef5e5fb7152409f58610b0b8b654990f6bb165c"
  end

  # Required lucas-clemente/quic-go >= 0.28
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

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
