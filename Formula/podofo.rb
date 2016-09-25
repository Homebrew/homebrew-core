class Podofo < Formula
  desc "Library to work with the PDF file format"
  homepage "http://podofo.sourceforge.net"
  url "https://downloads.sourceforge.net/podofo/podofo-0.9.4.tar.gz"
  sha256 "ccdf505fcb4904617e728b15729da8700ff38442c1dd2f24fbd52934287ff859"

  bottle do
    cellar :any
    sha256 "fded580406211857ae232abb92f977b731458fb8c7fff00030b53716964916bc" => :sierra
    sha256 "48324ad3bc842e158ed203adc1b092fb78cd5807978305833137fa40f0747075" => :el_capitan
    sha256 "842429d939790291beca9559a7383764bf3f1db96451d02c61c7ad2e0a680528" => :yosemite
    sha256 "8de2d18ab47458a4751a5286840451bdec435d06a9070738ffbe29d2463001bd" => :mavericks
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
