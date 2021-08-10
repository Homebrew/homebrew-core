class Libetonyek < Formula
  desc "Interpret and import Apple Keynote presentations"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libetonyek"
  url "https://dev-www.libreoffice.org/src/libetonyek/libetonyek-0.1.10.tar.xz"
  sha256 "b430435a6e8487888b761dc848b7981626eb814884963ffe25eb26a139301e9a"

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libetonyek[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256               arm64_big_sur: "8ca7825177d98f44ac9f3d6ad409eb3bc79d4621cb6c75aea43f60ca66234d0f"
    sha256 cellar: :any, big_sur:       "c0d419840c9454c6fe46fcffe7e27d57a8a5ea6a26a9bdd75ab6756f9399b2d0"
    sha256 cellar: :any, catalina:      "d40376bdfb4527e035ec8c0c1d65927303f81a456d02ce9fb0503a41f5e9ee60"
    sha256 cellar: :any, mojave:        "1d30b4258651cc6edbd2e7e39d6af095a25f52994baa3ed34e2be0e2f606ecf2"
    sha256               x86_64_linux:  "50c4ec0dd235b3cde8180781e8392183d8b2f7e932f571a4317e0437deec01cd"
  end

  depends_on "boost" => :build
  depends_on "glm" => :build
  depends_on "mdds" => :build
  depends_on "pkg-config" => :build
  depends_on "librevenge"

  uses_from_macos "libxml2"

  resource "liblangtag" do
    url "https://bitbucket.org/tagoh/liblangtag/downloads/liblangtag-0.6.3.tar.bz2"
    sha256 "1f12a20a02ec3a8d22e54dedb8b683a43c9c160bda1ba337bf1060607ae733bd"
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
