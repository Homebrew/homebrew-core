class Cryptol < Formula
  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "https://www.cryptol.net/"
  url "https://hackage.haskell.org/package/cryptol-2.13.0/cryptol-2.13.0.tar.gz"
  sha256 "5c5b7ad0b290c506836dbbad886ae43ce7d690dd86e2f2a9124564c2f5602b83"
  license "BSD-3-Clause"
  head "https://github.com/GaloisInc/cryptol.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21bf30e80d822a11359a5edada042837a294a82e9a2375e39e19fb059957e1b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "091eca3d557fc8f34f9f08734731c70d4235c701238fec389e8746b0c9875a97"
    sha256 cellar: :any_skip_relocation, monterey:       "2c2d695b1976a46096f711490a0fde3d036cee5eea965e0eaa431fe43764a77e"
    sha256 cellar: :any_skip_relocation, big_sur:        "649566c85d028a8affea145c1c4236f9462f8fd17daf7d649e894d4d54d191ae"
    sha256 cellar: :any_skip_relocation, catalina:       "45e33fc7108b2f070b587b040fb16e0bb6dbd107871cbff0a1dc92d49c190c94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "336e42866d31ad32f2e965623aec255851d42cdf926435d00ce06992fa058bb1"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "z3"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"helloworld.icry").write <<~EOS
      :prove \\(x : [8]) -> x == x
      :prove \\(x : [32]) -> x + zero == x
    EOS
    expected = /Q\.E\.D\..*Q\.E\.D/m
    assert_match expected, shell_output("#{bin}/cryptol -b helloworld.icry")
  end
end
