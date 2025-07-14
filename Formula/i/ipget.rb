class Ipget < Formula
  desc "Retrieve files over IPFS and save them locally"
  homepage "https://github.com/ipfs/ipget/"
  url "https://github.com/ipfs/ipget/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "6c929d5ba324d9e0eeccf3e22ff0caa359e9937e3abdfda283caffe3fda5e2dc"
  license "MIT"
  head "https://github.com/ipfs/ipget.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb0f59e6ee28702711cbf7c289a391781ec47aa8388dda4f0dcfbec9ee023f60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f75a0ac07fee211ec4b7177d98c89ab7dc7736f644d9a86415f95147cf51722"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52fa657e0315b0fea4187b6d4626ca92c0848de61ac68a86e651f097ca01d5b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "314066de6bb446eb676962d9ce5c47f9b63542085c7b357436ff9f0e78765157"
    sha256 cellar: :any_skip_relocation, ventura:       "3682baa94e09d29956fe63930804cbd4a83714ff0eeb7342c4a4f0b1b8f1bb79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0af805f7ab48f27dcb54299745fca9c2d1cb47241f3c10085e1a6c8766b74994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "590ba364cc6aeb718b23ff5100b28a05b7d96809b5f253363cd9fbc78dd210f7"
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
