class Calceph < Formula
  desc "C library to access the binary planetary ephemeris files"
  homepage "https://www.imcce.fr/inpop/calceph"
  url "https://www.imcce.fr/content/medias/recherche/equipes/asd/calceph/calceph-3.5.1.tar.gz"
  sha256 "33cc0be1b8ffb647aff9d3ac1cf025e460451e00144050d3bbc4f13bceb11c1d"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?calceph[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0b9a27bf445e9369110bca6ce6d307e4792484249cde4befb7a6405d5e890b85"
    sha256 cellar: :any,                 arm64_big_sur:  "9c3abdc353fa28b0f073f59579866f5f4ebe1394af3f48cceff39664077f2d67"
    sha256 cellar: :any,                 monterey:       "e68ea66a767bd309f19b691fcb210248cd3e3f0254e68c35aeb2b9690c31d68e"
    sha256 cellar: :any,                 big_sur:        "09f5d187d213d349fe8f0035cc26a08f8cee34e43efa691f1bd882df968540b2"
    sha256 cellar: :any,                 catalina:       "36e5388c8789221831f181d7e9ec7d2ad822e4f76afca20533912508ca38913c"
    sha256 cellar: :any,                 mojave:         "22799e0c12c14a7a50062e5d0c482460d1fd8317a32fbf8063aca797d7e83bc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6684443f24392f477d629d6d3da6a067d1bf73892dd465e6bd8421037118c54"
  end

  depends_on "gcc" # for gfortran

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"testcalceph.c").write <<~EOS
      #include <calceph.h>
      #include <assert.h>

      int errorfound;
      static void myhandler (const char *msg) {
        errorfound = 1;
      }

      int main (void) {
        errorfound = 0;
        calceph_seterrorhandler (3, myhandler);
        calceph_open ("example1.dat");
        assert (errorfound==1);
        return 0;
      }
    EOS
    system ENV.cc, "testcalceph.c", "-L#{lib}", "-lcalceph", "-o", "testcalceph"
    system "./testcalceph"
  end
end
