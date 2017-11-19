class Libetonyek < Formula
  desc "Interpret and import Apple Keynote presentations"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libetonyek"
  url "https://dev-www.libreoffice.org/src/libetonyek/libetonyek-0.1.7.tar.xz"
  sha256 "69dbe10d4426d52f09060d489f8eb90dfa1df592e82eb0698d9dbaf38cc734ac"

  bottle do
    sha256 "8cb44e63040162663d2145200a902bd4da40907a1e3ad630a43ce4a55f00f5ad" => :high_sierra
    sha256 "77ce685537dc1bce0600e3c795699fd90004c0c38fc6735243028c7bc167070f" => :sierra
    sha256 "385b7f6fbc971b66cb7b60aaaed207eee6a4f8f76af27dcff8104aff03320739" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "librevenge"
  depends_on "glm"
  depends_on "mdds"

  resource "liblangtag" do
    url "https://bitbucket.org/tagoh/liblangtag/downloads/liblangtag-0.6.2.tar.bz2"
    sha256 "d6242790324f1432fb0a6fae71b6851f520b2c5a87675497cf8ea14c2924d52e"
  end

  def install
    resource("liblangtag").stage do
      system "./configure", "--prefix=#{libexec}", "--enable-modules=no"
      system "make"
      system "make", "install"
    end

    ENV["LANGTAG_CFLAGS"] = "-I#{libexec}/include"
    ENV["LANGTAG_LIBS"] = "-L#{libexec}/lib -llangtag -lxml2"
    system "./configure", "--without-docs",
                          "--disable-dependency-tracking",
                          "--enable-static=no",
                          "--disable-werror",
                          "--disable-tests",
                          "--prefix=#{prefix}",
                          "--with-mdds=1.2"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libetonyek/EtonyekDocument.h>
      int main() {
        return libetonyek::EtonyekDocument::RESULT_OK;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test",
                    "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-I#{include}/libetonyek-0.1",
                    "-L#{Formula["librevenge"].lib}",
                    "-L#{lib}",
                    "-lrevenge-0.0",
                    "-letonyek-0.1"
    system "./test"
  end
end
