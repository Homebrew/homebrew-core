class Podofo < Formula
  desc "Library to work with the PDF file format"
  homepage "https://podofo.sourceforge.io"
  url "https://downloads.sourceforge.net/podofo/podofo-0.9.6.tar.gz"
  sha256 "e9163650955ab8e4b9532e7aa43b841bac45701f7b0f9b793a98c8ca3ef14072"

  bottle do
    cellar :any
    rebuild 1
    sha256 "047ebd5eb48107fcc54e2e2692cfe8ee55f1b8408ae06b0d5d193e260217ea91" => :high_sierra
    sha256 "1bee565ed640de58ab42229e0b8d87b723e7148006fe18d609e27e78614407c6" => :sierra
    sha256 "03db2d2fbfdd25788c6b8d44eb51d436bc9a15319ef540e59a72693eb80c2a92" => :el_capitan
    sha256 "8564686fa0043a7dd94bc00f09f1a2b4bb3ba063cff6ff7e59eee6912a213913" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libidn"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl"

  # Upstream commit, remove in next release
  # https://sourceforge.net/p/podofo/tickets/24/
  patch :p0 do
    url "https://raw.githubusercontent.com/macports/macports-ports/ae70aa7e/graphics/podofo/files/podofo-cmake-3.12.patch"
    sha256 "877501b55bd5502dcaf048d3811b81fada2bd005e2247a2412a88b3035edd51f"
  end

  def install
    freetype = "#{Formula["freetype"].opt_include}/freetype2"
    args = std_cmake_args + %W[
      -DCMAKE_DISABLE_FIND_PACKAGE_CppUnit=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_LUA=ON
      -DFREETYPE_INCLUDE_DIR_FT2BUILD=#{freetype}
      -DFREETYPE_INCLUDE_DIR_FTHEADER=#{freetype}/config/
      -DPODOFO_BUILD_SHARED:BOOL=ON
      -DCMAKE_INSTALL_NAME_DIR=#{lib}
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    assert_match "500 x 800 pts", shell_output("#{bin}/podofopdfinfo test.pdf")
  end
end
