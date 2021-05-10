class Libdivecomputer < Formula
  desc "Library for communication with various dive computers"
  homepage "https://www.libdivecomputer.org/"
  url "https://www.libdivecomputer.org/releases/libdivecomputer-0.7.0.tar.gz"
  sha256 "80d9f194ea24502039df98598482e0afc6b0e333de79db34c29b2d68934d25b9"
  license "LGPL-2.1-or-later"
  head "https://git.code.sf.net/p/libdivecomputer/code.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d3e4b45b8b1118b83084477da48b00a56b36e3a1c945a3155dca5bc59d13b798"
    sha256 cellar: :any, big_sur:       "a75f2bfefc391e7064b57d3a372aac193d307ab8be911a32b0aca011f29629ab"
    sha256 cellar: :any, catalina:      "77d221b1a1761aaab3beb86663f18f2610874a9b95158aef7b5620f12bc39310"
    sha256 cellar: :any, mojave:        "d27cbe3800c83225dade44ea62ae7ddfa4018866ed1a6628b6f3bda6abf68df7"
    sha256 cellar: :any, high_sierra:   "09dd65b72be93f3364b0b0da389fc4aa4d1fea2094ffe53275544e74ac6a7674"
    sha256 cellar: :any, sierra:        "bbc60092aee1409bd0001e2f3cfdde47bb3d2348d3bf18f1fc6921920607f947"
    sha256 cellar: :any, el_capitan:    "507134023caaaebd5b1689f324aea50839e13f57d180f7134ee270edc2b02cf6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "autoreconf", "--install" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libdivecomputer/context.h>
      #include <libdivecomputer/descriptor.h>
      #include <libdivecomputer/iterator.h>
      int main(int argc, char *argv[]) {
        dc_iterator_t *iterator;
        dc_descriptor_t *descriptor;
        dc_descriptor_iterator(&iterator);
        while (dc_iterator_next(iterator, &descriptor) == DC_STATUS_SUCCESS)
        {
          dc_descriptor_free(descriptor);
        }
        dc_iterator_free(iterator);
        return 0;
      }
    EOS
    flags = %W[
      -I#{include}
      -L#{lib}
      -ldivecomputer
    ]
    system ENV.cc, "-v", "test.c", "-o", "test", *flags
    system "./test"
  end
end
