class Libwpd < Formula
  desc "General purpose library for reading WordPerfect files"
  homepage "https://libwpd.sourceforge.io/"
  url "https://dev-www.libreoffice.org/src/libwpd-0.10.2.tar.xz"
  sha256 "323f68beaf4f35e5a4d7daffb4703d0566698280109210fa4eaa90dea27d6610"

  bottle do
    cellar :any
    sha256 "7fbbb8923d393d8c4cef19deb6e3696b9ce6c4ec9df63e687822de2541269326" => :mojave
    sha256 "b240b96a69dc164ef6f4cdc3cdff10339cb1ce5d1593380319e8f41004d82d26" => :high_sierra
    sha256 "5e7bd127154ff012858b889ab8b40c47498887f7cf5ef5c9d71eb8230d7ac68e" => :sierra
    sha256 "c5368f8e62e66db7f5afcf1fb6b807af0d4a2ac5673863a787b16329e484f457" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libgsf"
  depends_on "librevenge"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libwpd/libwpd.h>
      int main() {
        return libwpd::WPD_OK;
      }
    EOS
    system ENV.cc, "test.cpp",
                   "-I#{Formula["librevenge"].opt_include}/librevenge-0.0",
                   "-I#{include}/libwpd-0.10",
                   "-L#{Formula["librevenge"].opt_lib}",
                   "-L#{lib}",
                   "-lwpd-0.10", "-lrevenge-0.0",
                   "-o", "test"
    system "./test"
  end
end
