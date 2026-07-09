class Ipget < Formula
  desc "Retrieve files over IPFS and save them locally"
  homepage "https://github.com/ipfs/ipget/"
  url "https://github.com/ipfs/ipget/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "2c13bc811c4ac4610bf3e6b7bb8586e877c458a8d2f0414b56e29a75a5d677a1"
  license "MIT"
  head "https://github.com/ipfs/ipget.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61d41d721f5d93799d5cb4422f3b44d09f602160c4cbcc4b8c974fb6a1c9eb68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d63e98d336bf8dc7f11680ad7ea1af775c13280d50d1b5fa911f5b20acc0ee9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1556693bcd82e85ddf273f098ad2d7609ad6bb8cc439605a52151dde917dbcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2660824a7d3b97aa24936aa84ff595ca09f7e0c885cd698761674d45a8b0c31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00d6bfd3b6dea6292bafd8c7bc438d52681941dd52c5ee317ab7080b7921961c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd6dafc463b658a9d6db25cc3ed8ad20fbbac60736dfacc4b9da08425eeed1eb"
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
