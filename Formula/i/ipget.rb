class Ipget < Formula
  desc "Retrieve files over IPFS and save them locally"
  homepage "https://github.com/ipfs/ipget/"
  url "https://github.com/ipfs/ipget/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "a0ea59e5847554ed9f9881d2da0e15a932cb10e5b3c0b8db8ce59e2f1b985aa8"
  license "MIT"
  head "https://github.com/ipfs/ipget.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "923f13f411c0c39287b54de28592d3aabb61fe5d17233ff1c7d923ac77f0500b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcada1f1081ce5b03656196925e3329c5bc438747961287065508dd9fa299b11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e1b5185d5069d07eb7850338f2a025bc1f4299db0be436ba2dbdcf286c412aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "341d791a4ac73a83042b64acc8778689b5c53115d64838ff6b4426fd2b98b578"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c865bd7b7d38f0127ea8aca3d89dbdca91e06e3a2df4771c9a2a888834291deb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af41d59456696e27ea85444a10b1b5df77ad6b47e61065d25f2f34d3fdf46b38"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # Make sure correct version is reported
    assert_match version.to_s, shell_output("#{bin}/ipget --version")

    # An example content identifier (CID) used in IPFS docs:
    # https://docs.ipfs.tech/concepts/content-addressing/
    cid = "bafybeihkoviema7g3gxyt6la7vd5ho32ictqbilu3wnlo3rs7ewhnp7lly"
    system bin/"ipget", "ipfs://#{cid}/"
    assert_match "JPEG image data", shell_output("file #{cid}")
  end
end
