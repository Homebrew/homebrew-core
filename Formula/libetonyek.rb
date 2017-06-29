class Libetonyek < Formula
  desc "Interpret and import Apple Keynote presentations"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libetonyek"
  url "https://dev-www.libreoffice.org/src/libetonyek/libetonyek-0.1.6.tar.xz"
  sha256 "df54271492070fbcc6aad9f81ca89658b25dd106cc4ab6b04b067b7a43dcc078"
  revision 1

  bottle do
    sha256 "bd8eebe1f6baa116b62e07120d2721e4b58b07afde240b1715fc7765ac8c9f97" => :sierra
    sha256 "24dcd3c072de267a0c37b56e09018dce03f2af49577072f27bca7fcb3637c13d" => :el_capitan
    sha256 "638cac17acdf356dd29a0e9e2d190978c1e92778287aa1f03e7daafdf7eeb83a" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "gnu-sed" => :build
  depends_on "librevenge"
  depends_on "glm"
  depends_on "mdds"

  resource "liblangtag" do
    url "https://bitbucket.org/tagoh/liblangtag/downloads/liblangtag-0.5.8.tar.bz2"
    sha256 "08e2f64bfe3f750be7391eb0af53967e164b628c59f02be4d83789eb4f036eaa"
  end

  # Remove for > 0.1.6
  # upstream commit adding support for mdds 1.2 API in configure
  patch do
    url "https://github.com/LibreOffice/libetonyek/commit/f6d14b3.patch?full_index=1"
    sha256 "e2b04fb2ae25f3edfa0a9ac06096310d4e22004acf0ee36ccaa3cb9b6cc20317"
  end

  def install
    resource("liblangtag").stage do
      ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"
      system "./configure", "--prefix=#{libexec}", "--enable-modules=no"
      system "make"
      system "make", "install"
    end

    ENV["LANGTAG_CFLAGS"] = "-I#{libexec}/include"
    ENV["LANGTAG_LIBS"] = "-L#{libexec}/lib -llangtag -lxml2"
    system "autoreconf", "-v" # Remove for > 0.1.6
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
    (testpath/"test.cpp").write <<-EOS.undent
      #include <libetonyek/EtonyekDocument.h>
      int main() {
        return libetonyek::EtonyekDocument::RESULT_OK;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-I#{include}/libetonyek-0.1",
                    "-L#{Formula["librevenge"].lib}",
                    "-L#{lib}",
                    "-lrevenge-0.0",
                    "-letonyek-0.1"
    system "./test"
  end
end
