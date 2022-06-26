class Libodfgen < Formula
  desc "ODF export library for projects using librevenge"
  homepage "https://sourceforge.net/p/libwpd/wiki/libodfgen/"
  url "https://dev-www.libreoffice.org/src/libodfgen-0.1.8.tar.xz"
  mirror "https://downloads.sourceforge.net/project/libwpd/libodfgen/libodfgen-0.1.8/libodfgen-0.1.8.tar.xz"
  sha256 "55200027fd46623b9bdddd38d275e7452d1b0ff8aeddcad6f9ae6dc25f610625"
  license any_of: ["MPL-2.0", "LGPL-2.1-or-later"]

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libodfgen[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "db9ec11161a89cadc0cc829f021fbb1a26ffd96ca7962788013b6a83efa35440"
    sha256 cellar: :any,                 big_sur:       "f53270e1f9060d1e2074a89444899e540e3307270fbd94c6a5186e9a05ecda45"
    sha256 cellar: :any,                 catalina:      "f019ef9174156093d5592556fac3fb5e87a38a90882572a3ff4a15b7d9227c8c"
    sha256 cellar: :any,                 mojave:        "b8bcc9b962fa97d431fb4a27a924a18b37b264e43bb5e881b67668aa18633edd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8466ec0a88ee4d205fb5bac977d257b7cea7c4dfcdcfc1028d97e4be5529c848"
  end

  depends_on "boost" => :build
  depends_on "libetonyek" => :build
  depends_on "libwpg" => :build
  depends_on "pkg-config" => :build
  depends_on "librevenge"
  depends_on "libwpd"

  def install
    system "./configure", "--without-docs",
                          "--disable-dependency-tracking",
                          "--enable-static=no",
                          "--with-sharedptr=boost",
                          "--disable-werror",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libodfgen/OdfDocumentHandler.hxx>
      int main() {
        return ODF_FLAT_XML;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
      "-lrevenge-0.0",
      "-I#{Formula["librevenge"].include}/librevenge-0.0",
      "-L#{Formula["librevenge"].lib}",
      "-lodfgen-0.1",
      "-I#{include}/libodfgen-0.1",
      "-L#{lib}"
    system "./test"
  end
end
