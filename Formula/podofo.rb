class Podofo < Formula
  desc "Library to work with the PDF file format"
  homepage "https://podofo.sourceforge.io"
  url "https://downloads.sourceforge.net/podofo/podofo-0.9.6.tar.gz"
  sha256 "e9163650955ab8e4b9532e7aa43b841bac45701f7b0f9b793a98c8ca3ef14072"
  revision 1

  bottle do
    cellar :any
    sha256 "477345ac9e2bc7bf70307dca70b1ea3e08fc1138736adc497781ee784030966c" => :mojave
    sha256 "0b66eafa989073b3ee0abe52f2524714fcf1155592f20633dbbb9fe92f9d1382" => :high_sierra
    sha256 "eb20ecc8daabf8742a368ed32ada7d47fea2c79ff964aae026bb7f40687b5029" => :sierra
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
