class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "https://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.7.tar.xz"
  sha256 "5666249d613466b9aa1e987ea4109c04365866e9277d80f6cd9663e86b8ecdd4"
  license "MPL-2.0"
  revision 2

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libcdr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1cd7f98c2ed9c75d64d62587f7957698afab80c4d729e273c56ea16d34fbecd3"
    sha256 cellar: :any,                 arm64_big_sur:  "5d9393327ba3a8153d2a543377b60a5b121d368c9cc0a1471ff797691b8881b2"
    sha256 cellar: :any,                 monterey:       "62e0c275e354b6fe98abfe16c895032d8438104f5ddeff70e66b9bc4d61a0ced"
    sha256 cellar: :any,                 big_sur:        "2757bc8bbcb63a596f652edef9528b62f5d4b7e188c4b9bdb4c527fbb1a4aaa6"
    sha256 cellar: :any,                 catalina:       "32cd06182f7b3272eb891e0a632ff2fa06f8e9611b80cfce5e5a8577ad216755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59f662d6f647cd5d2115b48e59f999e474f5c825fb1811735f3d33a62f4baf31"
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
