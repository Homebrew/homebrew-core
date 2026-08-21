class Elio < Formula
  desc "Batteries-included terminal file manager with rich previews"
  homepage "https://elio-fm.github.io/"
  url "https://github.com/elio-fm/elio/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "a0b30f139febc462ebc2ae20b641e358db4a8935c5262a30241fa12d822ded25"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5285385e7ea90cdf2dce402cd16ebcbc32b2dc6846f86f6c19b7b3fc85226dad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46e320ef94ed19325ddfe35f222cda034c2a5a098dab221c7860258195629934"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1efa57fb24ad45d4c0c30df472b2d32a2e05e91907601f79618fdce3e49d1ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "8684a6462268fb5604eceffe1a8cbb296e260bce513cbc904f2b05cf4e28bdb6"
    sha256 cellar: :any,                 arm64_linux:   "4ceceedff3acb6a54d3e0a924a427fb7b2201deb7e3f0245503cff3b639f239b"
    sha256 cellar: :any,                 x86_64_linux:  "80fb184d48f27a1b6750956d99be2f35bb5bcdac3ee4f6de6179d42d649a4d90"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    missing = testpath/"missing-directory"
    output = shell_output("#{bin}/elio #{missing} 2>&1", 1)
    assert_match "no such file or directory", output
  end
end
