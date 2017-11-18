class Plzip < Formula
  desc "Data compressor"
  homepage "http://www.nongnu.org/lzip/plzip.html"
  url "https://download.savannah.gnu.org/releases/lzip/plzip/plzip-1.6.tar.gz"
  sha256 "5d1d79fe4a1e41aa05e3926d067243efbaa607ed238036152f867662b7d14c7c"

  bottle do
    cellar :any_skip_relocation
    sha256 "64ffaa06460b13a4d53e14ae6ae923805b28bf66a9fdcbf8464ad6ffd6e5329d" => :high_sierra
    sha256 "8bb211a7a090509a64c331dcdca1bbcd201bc7e1b6a8bcf59cde64637be5d053" => :sierra
    sha256 "0da26f741281bcf54cd0ae9d443b867bdde9dde340bf83fcabc6c0f22c887016" => :el_capitan
    sha256 "fe05c1a91ccf2cd262041facaed4fade1ea45b957eabb127070333d79efed3eb" => :yosemite
    sha256 "3e7f98cc5a785d008c7fa9a9dac0b641240ca268089964730705601744e7ff38" => :mavericks
  end

  depends_on "lzlib"

  # error: unknown type name 'pthread_mutex_t' and 'pthread_cond_t'
  # Reported 24 Nov 2017 to lzip-bug AT nongnu DOT org
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/68e2af8/plzip/pthread.diff"
    sha256 "9e6653248ade666922b353b362eda6383af73c85cd93936c70bd8257e027f2b1"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    text = "Hello Homebrew!"
    compressed = pipe_output("#{bin}/plzip -c", text)
    assert_equal text, pipe_output("#{bin}/plzip -d", compressed)
  end
end
