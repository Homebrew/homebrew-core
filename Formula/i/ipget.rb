class Ipget < Formula
  desc "Retrieve files over IPFS and save them locally"
  homepage "https://github.com/ipfs/ipget/"
  url "https://github.com/ipfs/ipget/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "f23da18910d2cbed3d69f95d494bf60bc6465b668ff192e1e0980846052f7fbb"
  license "MIT"
  head "https://github.com/ipfs/ipget.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae191e404fb22d27e536be300bb1846eff193e07cd5f6ba708db4de72e6745ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d84d5bfa92c6eb9803695595470fa28790947f3991bc3d76a71460d200df83ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e1a68437518df67a1f9ea6c055515cb3c997b14a1966ab295a5b294856ff7b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2d37965fd49661e14955b9eed121b61d07c6b0b1b1154469162ad9f6c840885"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a4531272cf503af7428a4b151489011936d2c3b1b1f9d569a8005af26e0ae5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15c1dd49bebdce8b9ab5fdbedd3cd48f9a831c42549fe9781c6de8284409d0fd"
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
