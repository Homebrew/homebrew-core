class Libxo < Formula
  desc "Allows an application to generate text, XML, JSON, and HTML output"
  homepage "https://juniper.github.io/libxo/libxo-manual.html"
  url "https://github.com/Juniper/libxo/releases/download/1.7.0/libxo-1.7.0.tar.gz"
  sha256 "9de1e322382ecfdf0310ce7b083ea22e8fdbddca27290652b021edca78fdf201"
  license "BSD-2-Clause"

  bottle do
    sha256 arm64_sonoma:   "b1790a98521b1eea80ebbae023d5a9a623cabf6d34f86491eccbf6d9e05fc065"
    sha256 arm64_ventura:  "b03a2fafc98f645f75d8c64120644e9a315752594b6fbca36a6aed9c87ba50c8"
    sha256 arm64_monterey: "63bc04e331c0d2f244003d2aafc5e7b1548f850b19be1ac7750d04f91a82117a"
    sha256 sonoma:         "deae4f30446de4834bbe55f0a4c77ea508b1310ca64318f5d82a99ca6944a44a"
    sha256 ventura:        "762e6bb43fe3c20924bcddd341b00501bf0f47cfa2634e42aa696541aef5922c"
    sha256 monterey:       "fca848ffecebdc0fd2a03e60cddf20b0e9c98d5e129875093dd36efb4278825b"
    sha256 x86_64_linux:   "d3762c5b93dd021d17cfcf181e0756d1bfb5735dcb548d975beafb082e899906"
  end

  depends_on "libtool" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libxo/xo.h>
      int main() {
        xo_set_flags(NULL, XOF_KEYS);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lxo", "-o", "test"
    system "./test"
  end
end
