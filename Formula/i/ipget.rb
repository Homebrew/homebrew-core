class Ipget < Formula
  desc "Retrieve files over IPFS and save them locally"
  homepage "https://github.com/ipfs/ipget/"
  url "https://github.com/ipfs/ipget/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "b0ee2198cbaa0b68626eac9a77f8e63efa033fcdc90af79cf7d4500e88daad14"
  license "MIT"
  head "https://github.com/ipfs/ipget.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a8488bf496b10eb52dfb7cc75a8f013d97f9bff841a54ac7572a5da969b88e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e1e44e31731336f3b8833ea24a5847dd19d136f2bc8b59e0421ff5583024b21"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ec21db435018020b6e76f77565bcc01dc6fa416c08bbd844a45639e99fe3044"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9c3bc4d15edbf857e849cd59dc0438f8e59b88c84338b9e53ea754681d56b5b"
    sha256 cellar: :any_skip_relocation, ventura:       "c6030d43c74ffd804c434db3d3bda8b4fab47a4a119d4a5c7e91f5fc59a5463e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e20411b76204d12a1a7b66d49781157fbd950a8720abeecdc9ac69cb0e00088"
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
