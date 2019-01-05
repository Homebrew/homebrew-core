class Podofo < Formula
  desc "Library to work with the PDF file format"
  homepage "https://podofo.sourceforge.io"
  url "https://downloads.sourceforge.net/podofo/podofo-0.9.5.tar.gz"
  sha256 "854981cb897ebc14bac854ea0f25305372261a48a205363fe1c61659ba7b5304"
  revision 2

  bottle do
    cellar :any
    sha256 "b744f10486e5373bc3ca29b1a5530008f90b48ea176b8098ae73fd91070ea60b" => :mojave
    sha256 "b1ec1d67c725b6021617013c49d989bd0c91be23e5302f6d3421e6fb0c9aeb5d" => :high_sierra
    sha256 "aea9066461ba04300b0cd20a30063c349a821b62a5285aaa2abea9068966da82" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libidn"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl"

  # Upstream commit to fix cmake 3.12.0 build issue, remove in >= 0.9.7
  # https://sourceforge.net/p/podofo/tickets/24/
  patch :p0 do
    url "https://sourceforge.net/p/podofo/tickets/24/attachment/podofo-cmake-3.12.patch"
    sha256 "33e8bd8b57cc04884528d64c80624a852f61c8918b6fe320d26ca7d4905bdd54"
  end

  def install
    args = std_cmake_args + %W[
      -DCMAKE_DISABLE_FIND_PACKAGE_CppUnit=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_LUA=ON
      -DPODOFO_BUILD_SHARED:BOOL=ON
      -DFREETYPE_INCLUDE_DIR_FT2BUILD=#{Formula["freetype"].opt_include}/freetype2
      -DFREETYPE_INCLUDE_DIR_FTHEADER=#{Formula["freetype"].opt_include}/freetype2/config/
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
