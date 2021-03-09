class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "https://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.6.tar.xz"
  sha256 "01cd00b04a030977e544433c2d127c997205332cd9b8e35ec0ee17110da7f861"
  revision 3

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libcdr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e28a17a4fb749e9f9f7d24ffc6f405db6c520ab8f4749f67ea9ac3f43ad976d4"
    sha256 cellar: :any, big_sur:       "4fbab883412b32a9caf978ccfe1dbb9828c6d321cbb766c7e196910c8c36caff"
    sha256 cellar: :any, catalina:      "0745bfaffbc67e43ae6768548e807922cf1ab0cc3a530dd0b523aeb89ae1ddc4"
    sha256 cellar: :any, mojave:        "10f5db05d1dda0ef55f1322d91cb607f092fc7766624fbbf5e4617d17b27f6b1"
  end

  depends_on "cppunit" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "icu4c"
  depends_on "librevenge"
  depends_on "little-cms2"

  # Patch for `error: use of undeclared identifier 'TRUE'`
  # when built against icu4c 68.1+
  patch do
    url "https://github.com/LibreOffice/libcdr/commit/bf3e7f3bbc414d4341cf1420c99293debf1bd894.patch?full_index=1"
    sha256 "7009cef94c259d4e6f7c62214df4661507d89ac7b548db60ed7ab5e37c8e0dcc"
  end

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
