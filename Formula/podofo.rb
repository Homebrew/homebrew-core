class Podofo < Formula
  desc "Library to work with the PDF file format"
  homepage "https://podofo.sourceforge.io"
  url "https://downloads.sourceforge.net/podofo/podofo-0.9.6.tar.gz"
  sha256 "e9163650955ab8e4b9532e7aa43b841bac45701f7b0f9b793a98c8ca3ef14072"
  revision 2

  bottle do
    cellar :any
    sha256 "5ab849109138f399e5a5b7bda343fbcabc85fd2e4ef9608db0b78d1de2a1c1aa" => :mojave
    sha256 "7500b8f573a61302121539044a3a03e53eca0ee436d0dc07a128320d40ea0b0e" => :high_sierra
    sha256 "7b79283ecf4203779495d5be9e48ec338d369638aa2ff0462fb67337a7c69a2c" => :sierra
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
