class Libfreehand < Formula
  desc "Interpret and import Aldus/Macromedia/Adobe FreeHand documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libfreehand"
  url "https://dev-www.libreoffice.org/src/libfreehand/libfreehand-0.1.4.tar.xz"
  sha256 "350b10d24a76d7e8c8ae98b74c2d432a2c8ddec08935d09856d20b695a35e600"
  license "MPL-2.0"

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libfreehand[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a123c892432f9612a58cc7fb78182ce76f9cce010cbf767db0bfd82d05eba685"
    sha256 cellar: :any, arm64_tahoe:       "04e2f344a5b0a5c219055eb85bf8226699d818b47830b854e7cd0100ab21bd49"
    sha256 cellar: :any, arm64_sequoia:     "ee4e45db0dbda886e39c8edf5159b308777aafcb0f36162ba52c488e1a7c5eed"
    sha256 cellar: :any, arm64_linux:       "51a443af0b072364daa917f3d42235b25da4e5e15c4550765aa7116851c94547"
    sha256 cellar: :any, x86_64_linux:      "f30972de842b030b45f78a1421fffa25d101e9957163a3c709e7897dd1de22c6"
  end

  depends_on "boost" => :build
  depends_on "icu4c@78" => :build
  depends_on "pkgconf" => :build
  depends_on "librevenge"
  depends_on "little-cms2"

  uses_from_macos "gperf" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--without-docs",
                          "--disable-static",
                          "--disable-werror",
                          "--disable-tests",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <libfreehand/libfreehand.h>
      int main() {
        libfreehand::FreeHandDocument::isSupported(0);
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-I#{formula_opt_include("librevenge")}/librevenge-0.0",
                    "-I#{include}/libfreehand-0.1",
                    "-L#{formula_opt_lib("librevenge")}",
                    "-L#{lib}",
                    "-lrevenge-0.0",
                    "-lfreehand-0.1"
    system "./test"
  end
end
