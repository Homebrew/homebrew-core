class Podofo < Formula
  desc "Library to work with the PDF file format"
  homepage "https://podofo.sourceforge.io"
  url "https://downloads.sourceforge.net/podofo/podofo-0.9.5.tar.gz"
  sha256 "854981cb897ebc14bac854ea0f25305372261a48a205363fe1c61659ba7b5304"
  revision 1

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
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl"
  depends_on "libidn" => :optional

  def install
    args = std_cmake_args
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_LIBIDN=ON" if build.without? "libidn"
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_CppUnit=ON"
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_LUA=ON"

    # Build shared to simplify linking for other programs.
    args << "-DPODOFO_BUILD_SHARED:BOOL=ON"

    args << "-DFREETYPE_INCLUDE_DIR_FT2BUILD=#{Formula["freetype"].opt_include}/freetype2"
    args << "-DFREETYPE_INCLUDE_DIR_FTHEADER=#{Formula["freetype"].opt_include}/freetype2/config/"

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
