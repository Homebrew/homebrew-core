class Lifelines < Formula
  desc "Text-based genealogy software"
  homepage "https://lifelines.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/lifelines/lifelines/3.0.62/lifelines-3.0.62.tar.gz"
  sha256 "2f00441ac0ed64aab8f76834c055e2b95600ed4c6f5845b9f6e5284ac58a9a52"

  bottle do
    sha256 arm64_monterey: "9be7a6bb235edd9eec5362c010a521403d4cb617e4ce3d18a4c94caf1df37a4d"
    sha256 arm64_big_sur:  "0d4bbac64c9f9bb282761727298fbe0b04c8c520a9641ae7d16cf69453a0db48"
    sha256 monterey:       "c2cd11c23d01c15b708d86073bda0baa8b9a3891fd553ac8a31917371edcee83"
    sha256 big_sur:        "171cd3764cc895c2b4c7b9507a44da2aa2e13fe3a75df80af345500f81da3572"
    sha256 catalina:       "3aa3d5f87691e0cffd46c05c0093164d6b2ea7cf3f99099fd98b40762654751d"
    sha256 mojave:         "ab730940d142073ed9424d0cf480a6a752d10ec54af14c54569b23292e1e503e"
    sha256 high_sierra:    "95457e5f439d945c32e65a32a43a5396b8c7f33466f0c83a0671936f095d649a"
    sha256 sierra:         "1a974d23d51da7a7d2aedaec195291195a9eb442839a9bb9e5574ed6d8c01199"
    sha256 el_capitan:     "20b13125e3312866baed38e6f6ffd706a6f4a0436617e8a6055f1f776a76b9a2"
    sha256 yosemite:       "69108c01987d30c1e82b2928fdaf0817ba2b2883fc6fef886e3e559dd49d29c2"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
