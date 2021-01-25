class Lifelines < Formula
  desc "Text-based genealogy software"
  homepage "https://lifelines.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/lifelines/lifelines/3.0.62/lifelines-3.0.62.tar.gz"
  sha256 "2f00441ac0ed64aab8f76834c055e2b95600ed4c6f5845b9f6e5284ac58a9a52"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "171cd3764cc895c2b4c7b9507a44da2aa2e13fe3a75df80af345500f81da3572" => :big_sur
    sha256 "0d4bbac64c9f9bb282761727298fbe0b04c8c520a9641ae7d16cf69453a0db48" => :arm64_big_sur
    sha256 "3aa3d5f87691e0cffd46c05c0093164d6b2ea7cf3f99099fd98b40762654751d" => :catalina
    sha256 "ab730940d142073ed9424d0cf480a6a752d10ec54af14c54569b23292e1e503e" => :mojave
    sha256 "95457e5f439d945c32e65a32a43a5396b8c7f33466f0c83a0671936f095d649a" => :high_sierra
    sha256 "1a974d23d51da7a7d2aedaec195291195a9eb442839a9bb9e5574ed6d8c01199" => :sierra
    sha256 "20b13125e3312866baed38e6f6ffd706a6f4a0436617e8a6055f1f776a76b9a2" => :el_capitan
    sha256 "69108c01987d30c1e82b2928fdaf0817ba2b2883fc6fef886e3e559dd49d29c2" => :yosemite
    sha256 "cbe7743498423c250758271405f0a6a1f8e8b0bed83f91eac8c67041534da399" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
