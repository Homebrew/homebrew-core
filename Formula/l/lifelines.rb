class Lifelines < Formula
  desc "Text-based genealogy software"
  homepage "https://lifelines.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/lifelines/lifelines/3.0.62/lifelines-3.0.62.tar.gz"
  sha256 "2f00441ac0ed64aab8f76834c055e2b95600ed4c6f5845b9f6e5284ac58a9a52"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "c5cb2ca42297800da646da5d0503df4968cfc6a5426b355a1adcde9d34f455a5"
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
    sha256 arm64_linux:    "532a5dbb1bc790b73bff79343958cc3ee07ece8171406a059a86af2db1fd8edc"
    sha256 x86_64_linux:   "4372b0ed3cfd9ca0d9a89696a502f7ba9e989698dd7064761296dabcc47003f3"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "ncurses"

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llines --version")
  end
end
