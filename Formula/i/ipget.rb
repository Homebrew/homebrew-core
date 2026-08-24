class Ipget < Formula
  desc "Retrieve files over IPFS and save them locally"
  homepage "https://github.com/ipfs/ipget/"
  url "https://github.com/ipfs/ipget/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "e30a9f84633562b4c4d262b4c027260d43a6dcb47630215c7221dcc8066e8816"
  license "MIT"
  head "https://github.com/ipfs/ipget.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b686783d575a6a2401b10ad5c6b2e08382b6f6f7d4de27ab5c6d740ca77e886"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95e527ca8007d1c8eceda8ea79efa8a5e5281b585339f8bdeab5f43b622c021e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4da807a35c627f61137a0f0db170a585e43b46ecde7e17be9801ff8420e9db0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "43209232b50490c0a84fd95b9ea73890739c0c4cdacb3831d55b7bb98f96cf38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8db4b3cb414bec705e0e6f62d7f4ce28c1ab6327b910f2cc242c486eced2b7e5"
    sha256 cellar: :any,                 x86_64_linux:  "6465567cd07e7a520d5d233cdd25951d3b0d2e94baa87c7b7145c02ad30e4522"
  end

  deprecate! date: "2026-08-21", because: :repo_archived, replacement_formula: "kubo"
  disable! date: "2027-08-21", because: :repo_archived, replacement_formula: "kubo"

  # TODO: unpin go@1.26 when ipget supports go 1.27
  depends_on "go@1.26" => :build

  def install
    system "go", "build", *std_go_args
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
