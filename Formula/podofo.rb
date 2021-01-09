class Podofo < Formula
  desc "Library to work with the PDF file format"
  homepage "https://podofo.sourceforge.io"
  url "https://downloads.sourceforge.net/project/podofo/podofo/0.9.7/podofo-0.9.7.tar.gz"
  sha256 "7cf2e716daaef89647c54ffcd08940492fd40c385ef040ce7529396bfadc1eb8"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "4840cedd76d3e3622ebd529df4e3105515c659b2a26cb7a61e75263ccb03233e" => :big_sur
    sha256 "153f700bd2adc92e7fb10e6b2b89ebb4242a655fb0c19b9ccfe8363c71543729" => :arm64_big_sur
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
