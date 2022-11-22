class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "https://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.7.tar.xz"
  sha256 "5666249d613466b9aa1e987ea4109c04365866e9277d80f6cd9663e86b8ecdd4"
  license "MPL-2.0"
  revision 3

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libcdr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cf2e771405921f6b7794f5b8d841d7a53402c6f236aea40cf37b269448186694"
    sha256 cellar: :any,                 arm64_monterey: "d989d83c9a258d96ac00a54a25a7b71c2cc3fde0c79d7c265ad92f856c4965b9"
    sha256 cellar: :any,                 arm64_big_sur:  "f81e9a7ceeaaa6d1fca79a35c1a6c8f1d082e710d5563ab4cd5fb71b38e5ad8d"
    sha256 cellar: :any,                 ventura:        "906eccb4f2b71dc326efef9316303d28db4cfaf20f6098d86bf60057859e315b"
    sha256 cellar: :any,                 monterey:       "b15778df4e7ada6bd037466bf5ce04ac7d598dd9beafa00d7fdd59c0f023aa77"
    sha256 cellar: :any,                 big_sur:        "09cf51a1689edb6f7c3114dd02462e3076ffc81ddd91b2200fbcd49644a26d8f"
    sha256 cellar: :any,                 catalina:       "3f609d4dd59bf7bba036003ab23c99bfe91768bd55a4ced75e94cb1bcc947ec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab941fc0fe3c07b68d2ede656e338c948a14bd1fd268a4240ab294b9d7df5876"
  end

  depends_on "cppunit" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "icu4c"
  depends_on "librevenge"
  depends_on "little-cms2"

  def install
    ENV.cxx11
    # Needed for Boost 1.59.0 compatibility.
    ENV["LDFLAGS"] = "-lboost_system-mt"
    system "./configure", "--disable-werror",
                          "--without-docs",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libcdr/libcdr.h>
      int main() {
        libcdr::CDRDocument::isSupported(0);
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                                "-I#{Formula["librevenge"].include}/librevenge-0.0",
                                "-I#{include}/libcdr-0.1",
                                "-L#{lib}", "-lcdr-0.1"
    system "./test"
  end
end
