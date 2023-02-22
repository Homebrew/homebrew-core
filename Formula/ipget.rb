class Ipget < Formula
  desc "Retrieve files over IPFS and save them locally"
  homepage "https://github.com/ipfs/ipget/"
  license "MIT"
  head "https://github.com/ipfs/ipget.git", branch: "master"

  stable do
    url "https://github.com/ipfs/ipget/archive/refs/tags/v0.9.1.tar.gz"
    sha256 "d065de300a1764077c31900e24e4843d5706eb397d787db0b3312d64c94f15a9"

    # Backport `quic-go` update to support Go 1.19.
    # Remove in the next release.
    patch do
      url "https://github.com/ipfs/ipget/commit/2efde1ea597d8b659ee95af1cc7293a1f3baa219.patch?full_index=1"
      sha256 "70cb408102ec93fca8a3f8313e29a782250c88c7780f81f9c0f6fe0c5acdb38e"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "233788748853983df10588bf95efc20dddbb352411f8ed79be206722d03276ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0866c1fc5c49c93e7134866aac3ccde371329fa1b207be80be12da2ca6dfc8aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b390872e4c717f8b82d5a50ffa736f460c053e055adb88f8633fdac0d506a44"
    sha256 cellar: :any_skip_relocation, ventura:        "fe3f442e4e947fce3086ecc6fb930bf9be2dd22a1d7ee3d44ad51fbbe1041e5c"
    sha256 cellar: :any_skip_relocation, monterey:       "ae383e4e816bf7a335bad7a9a6d89cb29f4ba0b4ad5518d32e836bc9b4d04554"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad882c162aec3184a504d3de7274ca6fa0c60f7a3affa99b5f3eed834fe50940"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3ca4537a2e1536933ca2cd4a17b9f8907dc0a5c3df4b04f8bdfdc74476cdb74"
  end

  # The current version of `quic-go` dependency can only be built with `go@1.19`.
  # Try `go@1.20` or newer at next release
  depends_on "go@1.19" => :build

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
