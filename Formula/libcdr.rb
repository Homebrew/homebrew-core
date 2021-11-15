class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "https://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.7.tar.xz"
  sha256 "5666249d613466b9aa1e987ea4109c04365866e9277d80f6cd9663e86b8ecdd4"
  license "MPL-2.0"
  revision 1

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libcdr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "52c71577c0e2915f38ce1718e6ca9af2f466f14f834a3b32548cb4b549f8ff6c"
    sha256 cellar: :any,                 arm64_big_sur:  "5ae923701714fad81fced4eb8c7eb2c171c3e675c685a0649b561004a587a03b"
    sha256 cellar: :any,                 monterey:       "1982525feceb04d6555522d6198d6df1adc26e75d6cc26dca0bbee09306223de"
    sha256 cellar: :any,                 big_sur:        "0c5c055abec9d36ae8beaaf07e0268cb5b4495ec3103b933b03ff2676d96d049"
    sha256 cellar: :any,                 catalina:       "e79b945338269508e453ed4f8748d0a9b5e19304658621765c2eae54120d0537"
    sha256 cellar: :any,                 mojave:         "42016c8a3b6e75ce702e84f2afdf3c328807b776b10e9c809772c0f69d569d1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6cf82a1af01f907eb5476947c63b6a9241c5d5d72291f3f2263c1e6c5b70cdf"
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
