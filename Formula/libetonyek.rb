class Libetonyek < Formula
  desc "Interpret and import Apple Keynote presentations"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libetonyek"
  url "https://dev-www.libreoffice.org/src/libetonyek/libetonyek-0.1.9.tar.xz"
  sha256 "e61677e8799ce6e55b25afc11aa5339113f6a49cff031f336e32fa58635b1a4a"
  revision 1

  bottle do
    rebuild 1
    sha256 "fe426f3577057ac3a73b9527b01124e5f916872b505f12e8224674d72a700c5b" => :catalina
    sha256 "b51d5847f87fba35e67703d248f0552a4e03eb6fc4e35ba5a180f41fec68fdeb" => :mojave
    sha256 "d86fef6a245db1b767d8965362eae4782af35b2c2b14e819ae7d436790f909cd" => :high_sierra
  end

  depends_on "boost" => :build
  depends_on "glm" => :build
  depends_on "mdds" => :build
  depends_on "pkg-config" => :build
  depends_on "librevenge"

  uses_from_macos "libxml2"

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
                          "--with-mdds=1.5"
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
