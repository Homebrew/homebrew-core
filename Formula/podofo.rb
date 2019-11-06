class Podofo < Formula
  desc "Library to work with the PDF file format"
  homepage "https://podofo.sourceforge.io"
  url "https://downloads.sourceforge.net/podofo/podofo-0.9.6.tar.gz"
  sha256 "e9163650955ab8e4b9532e7aa43b841bac45701f7b0f9b793a98c8ca3ef14072"
  revision 2

  bottle do
    cellar :any
    sha256 "f3a0b9f5f93e268e1b8233bc1af041d26a89bb6f9e66ea0da0ef745b0454dc1d" => :catalina
    sha256 "2ad60f4e4acd3fa9d1da1dcfeb7381696f126915bbea881d4bec9bb2cfd4fbab" => :mojave
    sha256 "00db9c24295276fa24909d417f2790105bccc990c23f80ffa906210ab70e5af8" => :high_sierra
    sha256 "30d51bd12657b4fe2defbe157c8dfea4c804318f13fa1f15011ebefaa7dec016" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libidn"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl@1.1"

  # Upstream commit to fix cmake 3.12.0 build issue, remove in >= 0.9.7
  # https://sourceforge.net/p/podofo/tickets/24/
  patch :p0 do
    url "https://sourceforge.net/p/podofo/tickets/24/attachment/podofo-cmake-3.12.patch"
    sha256 "33e8bd8b57cc04884528d64c80624a852f61c8918b6fe320d26ca7d4905bdd54"
  end

  def install
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_NAME_DIR=#{opt_lib}
      -DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON
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
