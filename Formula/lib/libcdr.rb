class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "https://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.7.tar.xz"
  sha256 "5666249d613466b9aa1e987ea4109c04365866e9277d80f6cd9663e86b8ecdd4"
  license "MPL-2.0"
  revision 7

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libcdr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "22b81a0cc297bc61961801314d1c8c2c4ea90851ef69c506adb4b63f83ca9f90"
    sha256 cellar: :any,                 arm64_sonoma:  "db2451f83efc9b3cf1e08518890cdd059fa844d54e767a3ec6b1f793870ffdad"
    sha256 cellar: :any,                 arm64_ventura: "f4edcb56add80d1f5efed45d1e4c22ea9b1c2f355dad220eec15972bb915be03"
    sha256 cellar: :any,                 sonoma:        "0a6289b75868cef5545240da3c9843c42981a9762e937c8be64fdf1b312d7ffa"
    sha256 cellar: :any,                 ventura:       "610325d1a71956e0c49d6797fa6c8c97589f2b5e0577576030c1e322ef45eb24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03adb0de9bdd5f562bb2cee2df5e7ec3006acec4edfa376c32b6177e52034c09"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c@75"
  depends_on "librevenge"
  depends_on "little-cms2"

  def install
    # icu4c 75+ needs C++17
    ENV.append "CXXFLAGS", "-std=gnu++17"

    system "./configure", "--disable-silent-rules",
                          "--disable-tests",
                          "--disable-werror",
                          "--without-docs",
                          *std_configure_args
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
