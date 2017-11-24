class Plzip < Formula
  desc "Data compressor"
  homepage "http://www.nongnu.org/lzip/plzip.html"
  url "https://download.savannah.gnu.org/releases/lzip/plzip/plzip-1.6.tar.gz"
  sha256 "5d1d79fe4a1e41aa05e3926d067243efbaa607ed238036152f867662b7d14c7c"

  bottle do
    cellar :any_skip_relocation
    sha256 "f02744640715200d1114550c798c637eb851c8541dc2d204f31f41def197e338" => :high_sierra
    sha256 "6575ae533b2d6b3c4a575d29e97abf688f2900be61b0f27d722fd098fb3a9b94" => :sierra
    sha256 "ed2718fc204a2adda79b4e228ba64493225bd7f56edfcd08e300ff4074d570a2" => :el_capitan
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
