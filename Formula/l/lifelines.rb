class Lifelines < Formula
  desc "Text-based genealogy software"
  homepage "https://lifelines.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/lifelines/lifelines/3.0.62/lifelines-3.0.62.tar.gz"
  sha256 "2f00441ac0ed64aab8f76834c055e2b95600ed4c6f5845b9f6e5284ac58a9a52"
  license "MIT"

  bottle do
    sha256 arm64_sequoia:  "1f6bdc9020d5710b880583b1282be16a381ccc06e507fa708bba260fd5a256a0"
    sha256 arm64_sonoma:   "c7d6412aa87b5b3926d5bd6b04db7ca8005b31420b23120f76e5322b5b314fcf"
    sha256 arm64_ventura:  "a47b652141dd91cf3c2f88fc0fac232b93355645ce0319b9547504c6b8244145"
    sha256 arm64_monterey: "9be7a6bb235edd9eec5362c010a521403d4cb617e4ce3d18a4c94caf1df37a4d"
    sha256 arm64_big_sur:  "0d4bbac64c9f9bb282761727298fbe0b04c8c520a9641ae7d16cf69453a0db48"
    sha256 sonoma:         "80c4e7bab14f13997695abe0a742939d9c730c249ba11a357e472c7f92eafddf"
    sha256 ventura:        "15f81348e81a721825b03d29e15cb709a41620183d342a23322c6f3558b9aa65"
    sha256 monterey:       "c2cd11c23d01c15b708d86073bda0baa8b9a3891fd553ac8a31917371edcee83"
    sha256 big_sur:        "171cd3764cc895c2b4c7b9507a44da2aa2e13fe3a75df80af345500f81da3572"
    sha256 catalina:       "3aa3d5f87691e0cffd46c05c0093164d6b2ea7cf3f99099fd98b40762654751d"
    sha256 mojave:         "ab730940d142073ed9424d0cf480a6a752d10ec54af14c54569b23292e1e503e"
    sha256 high_sierra:    "95457e5f439d945c32e65a32a43a5396b8c7f33466f0c83a0671936f095d649a"
    sha256 sierra:         "1a974d23d51da7a7d2aedaec195291195a9eb442839a9bb9e5574ed6d8c01199"
    sha256 el_capitan:     "20b13125e3312866baed38e6f6ffd706a6f4a0436617e8a6055f1f776a76b9a2"
    sha256 x86_64_linux:   "4372b0ed3cfd9ca0d9a89696a502f7ba9e989698dd7064761296dabcc47003f3"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
