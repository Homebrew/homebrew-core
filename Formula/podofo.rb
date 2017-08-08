class Podofo < Formula
  desc "Library to work with the PDF file format"
  homepage "https://podofo.sourceforge.io"
  url "https://downloads.sourceforge.net/podofo/podofo-0.9.5.tar.gz"
  sha256 "854981cb897ebc14bac854ea0f25305372261a48a205363fe1c61659ba7b5304"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "1bee565ed640de58ab42229e0b8d87b723e7148006fe18d609e27e78614407c6" => :sierra
    sha256 "03db2d2fbfdd25788c6b8d44eb51d436bc9a15319ef540e59a72693eb80c2a92" => :el_capitan
    sha256 "8564686fa0043a7dd94bc00f09f1a2b4bb3ba063cff6ff7e59eee6912a213913" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "freetype"
  depends_on "fontconfig"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "openssl"
  depends_on "libidn" => :optional

  def install
    args = std_cmake_args

    # Build shared to simplify linking for other programs.
    args << "-DPODOFO_BUILD_SHARED:BOOL=TRUE"

    args << "-DFREETYPE_INCLUDE_DIR_FT2BUILD=#{Formula["freetype"].opt_include}/freetype2"
    args << "-DFREETYPE_INCLUDE_DIR_FTHEADER=#{Formula["freetype"].opt_include}/freetype2/config/"

    # podofo scoops out non-mandatory dependencies from system automatically.
    # Build fails against multi-lua systems, even when direct path is passed to cmake.
    # https://github.com/Homebrew/homebrew/issues/44026
    # DomT4: Reported upstream 19/12/2015 to mailing list but not published yet.
    # This seemingly unofficial hack doesn't work for libidn sadly.
    args << "-DLUA_INCLUDE_DIR=FALSE" << "-DLUA_LIBRARIES=FALSE"

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
