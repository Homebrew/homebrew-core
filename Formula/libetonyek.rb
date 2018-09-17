class Libetonyek < Formula
  desc "Interpret and import Apple Keynote presentations"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libetonyek"
  url "https://dev-www.libreoffice.org/src/libetonyek/libetonyek-0.1.8.tar.xz"
  sha256 "9dc92347aee0cc9ed57b175a3e21f9d96ebe55d30fecb10e841d1050794ed82d"

  bottle do
    sha256 "f03b400c57d53246843f5bb960be851bbb7a4386174f3fe08d762bf12a3cb806" => :high_sierra
    sha256 "4118f35b50634d104c481539e3746d824f31a045538a70881ca6869ecabab784" => :sierra
    sha256 "d811b416c6cc4cee0c770d476a993ab2b2ad9917068f31bb772a0ad3704cdcc1" => :el_capitan
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "glm"
  depends_on "librevenge"
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
