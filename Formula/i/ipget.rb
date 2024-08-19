class Ipget < Formula
  desc "Retrieve files over IPFS and save them locally"
  homepage "https://github.com/ipfs/ipget/"
  url "https://github.com/ipfs/ipget/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "a9bffe36f23284fa691cca0bc85d1890782ca0c7bc69a25f9881b712914a96cb"
  license "MIT"
  head "https://github.com/ipfs/ipget.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9751c89c7cca300ed66833d95b90c237444411ee7749de9a77dc22524bf75f7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7b81dbd9f3069c91d2379c9f7f4a6a792024513d5eed979f6b9c5b4cecfd997"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb635acd8e0287f7b6b17bb4fd2d6e2b908e035fd122a91238dd6a24a5f69a83"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e6ffd097a8a372c5322abe054329678f2eca450d4ba73c754dfd5ba6e26cc09"
    sha256 cellar: :any_skip_relocation, ventura:        "975a7db2409f90e92ecc37e361ff032e8442829abb5c45f12134beaa385dfa55"
    sha256 cellar: :any_skip_relocation, monterey:       "a3baad50d018574421224f09325c2308e65ce584da1d270f208f4f131ce2baa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "779aa12c179ffab409d0658b5a748666c241bbd959aec17baf5eb08a104b78b3"
  end

  depends_on "go" => :build

  # patch version to match with the release
  # upstream PR ref, https://github.com/ipfs/ipget/pull/147
  patch do
    url "https://github.com/ipfs/ipget/commit/1716f2298e54394123f3dda283ad30f0390b5640.patch?full_index=1"
    sha256 "cb3faa2d66702f1df82fbf04e78778422d7634b5e1fd831c249be06845cca82c"
  end

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
