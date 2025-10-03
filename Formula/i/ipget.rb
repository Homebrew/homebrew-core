class Ipget < Formula
  desc "Retrieve files over IPFS and save them locally"
  homepage "https://github.com/ipfs/ipget/"
  url "https://github.com/ipfs/ipget/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "2a96769de6b75289958f08ff6726cae2867eab07e24fa7f9799cfd22bcdacd0c"
  license "MIT"
  head "https://github.com/ipfs/ipget.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cb12240c529ada4d37251bd2bba3f1045180a4213b98a2f44d5c5a2c6a43048"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f41420515f24f4151ac4e4e29fbbd2d607dee62cbfa195b09bd77a241fcfe190"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a6ae77ccf0e43beebb025491bd2d753408ceb4082e8782da6bcdfa3d0479ba2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ceade243c775e105719c4a2f463dbb5d3b95613984891b6c553dc0a0dc64c259"
    sha256 cellar: :any_skip_relocation, sonoma:        "a54c9b4456f3a54128e777507704d6948ddfe15b765e2b631bed9c81b262a75e"
    sha256 cellar: :any_skip_relocation, ventura:       "baa4479a9fa9b965db6260df1d756486affde1b5d0fe3b3e504bffba27baed60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e003dc878c17eb8a71e483a45569bdbcb0270514eb67a43bc613b6096fb72fea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9537b17b1e760a1605bbaf06c3493bd1f9235717def75f048a8d49278c9db274"
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
