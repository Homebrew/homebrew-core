class Libetonyek < Formula
  desc "Interpret and import Apple Keynote presentations"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libetonyek"
  url "https://dev-www.libreoffice.org/src/libetonyek/libetonyek-0.1.9.tar.xz"
  sha256 "e61677e8799ce6e55b25afc11aa5339113f6a49cff031f336e32fa58635b1a4a"
  revision 1

  bottle do
    sha256 "babe107b6e32e3efa4ad535cac4d699e6705cd930e99ddcdefb1846df0c28984" => :mojave
    sha256 "2dddd5203a9a15f453b7da4b17e4e2556b16c95563160b454853ac258899ae37" => :high_sierra
    sha256 "e00523e2ed27d9f56b60c50db89e33ed7b6993a7301dc56e7a1b7228f63b3912" => :sierra
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
