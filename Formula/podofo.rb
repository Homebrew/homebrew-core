class Podofo < Formula
  desc "Library to work with the PDF file format"
  homepage "https://podofo.sourceforge.io"
  url "https://downloads.sourceforge.net/podofo/podofo-0.9.5.tar.gz"
  sha256 "854981cb897ebc14bac854ea0f25305372261a48a205363fe1c61659ba7b5304"
  revision 1

  bottle do
    cellar :any
    sha256 "d9700768b9fa348dc5552d62e1f806bc07ba0728ae2e9283bd6af01107f56193" => :sierra
    sha256 "346b88e1af3c56c10fd9eaf33461165dea98459da2c09d5aa9d091af9c35ce35" => :el_capitan
    sha256 "d1470dd34340c52ea677fffeae7b4733bba36f00c0a0eca820be82074502c7e8" => :yosemite
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
