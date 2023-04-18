class Ipget < Formula
  desc "Retrieve files over IPFS and save them locally"
  homepage "https://github.com/ipfs/ipget/"
  url "https://github.com/ipfs/ipget/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "e9b99050f5fd6fc5900a890cc5d5f097fbd3950fd00aeafa013271e5317bd4b8"
  license "MIT"
  head "https://github.com/ipfs/ipget.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27ae249c58431d50c42006db8f3c10590788dcc12789f7fec095733e16933aed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "637aee6de5693820f80fb291b96fc96d4d38c5ca0c14e669405f0aab1c4e60a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e42ef30c86e3a92c04c520a95bc2e68d51065c18e66537b550f76e122407181"
    sha256 cellar: :any_skip_relocation, ventura:        "d18b12d7e885b8636217d41eb675e49c88a4fe88e986dc65af371db1d6d37150"
    sha256 cellar: :any_skip_relocation, monterey:       "d647927bfe8775c8dcb6e30e4f40cc11ba6b645a81ce54de5e3a794c1cfd4662"
    sha256 cellar: :any_skip_relocation, big_sur:        "19db9c6847816db344a1a73d04fbaf25a582862136054105337b12668df26770"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d86000b64a10489e5ab7066fdc90f528e5009e21853d5ae05baabea71a148bc"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "ipget"
  end

  test do
    # Make sure correct version is reported
    assert_match version.to_s, shell_output("#{bin}/ipget --version")

    # An example content identifier (CID) used in IPFS docs:
    # https://docs.ipfs.tech/concepts/content-addressing/
    cid = "bafybeihkoviema7g3gxyt6la7vd5ho32ictqbilu3wnlo3rs7ewhnp7lly"
    system "#{bin}/ipget", "ipfs://#{cid}/"
    assert_match "JPEG image data", shell_output("file #{cid}")
  end
end
