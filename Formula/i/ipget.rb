class Ipget < Formula
  desc "Retrieve files over IPFS and save them locally"
  homepage "https://github.com/ipfs/ipget/"
  url "https://github.com/ipfs/ipget/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "3dd56e9243ab59383d206c2b374980cc987c016a391976dd9dcf5bff33a96f35"
  license "MIT"
  head "https://github.com/ipfs/ipget.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8ae441fecd189ca058e76d0acfb30e93a2fa8a04beffdaa27b1780d3f0ba34b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d963166f966424517640b342f72019fd6d1f5d7721a508f60d3841f512ded3d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e5a57ab51fe284bb42595846d991d16f16c9af8b9edc1ca59a8d4601abc2ffa"
    sha256 cellar: :any_skip_relocation, sonoma:        "f918f9a023d8f9259c75ed408752e6a0cfe660806ec2e9aef326ebaf19ac199f"
    sha256 cellar: :any_skip_relocation, ventura:       "f5725f63532333b6729f26664512984c4e2914358344894c6c9cfe8fabf81245"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f21317d1628e7a600ef4480d5ab43d707ad7a1241fd873fb1afad2f9fac5674d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "304bebe13417bc89ee71aab782f6f528824b4fd3dae6d8bf6a01540b2e11832c"
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
