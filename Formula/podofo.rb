class Podofo < Formula
  desc "Library to work with the PDF file format"
  homepage "https://podofo.sourceforge.io"
  url "https://downloads.sourceforge.net/project/podofo/podofo/0.9.8/podofo-0.9.8.tar.gz"
  sha256 "5de607e15f192b8ad90738300759d88dea0f5ccdce3bf00048a0c932bc645154"
  license all_of: ["LGPL-2.0-only", "GPL-2.0-only"]
  revision 1
  head "svn://svn.code.sf.net/p/podofo/code/podofo/trunk"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4c50abea084e59864fb304ad959a07341a3afd8a798e449a69e80001737fa0ec"
    sha256 cellar: :any,                 arm64_big_sur:  "f42560e17536e3144481a82b65070c04062007271ee3ab68ea7a99b9464ece70"
    sha256 cellar: :any,                 monterey:       "4c1a9c7e020382415b2b257accf5422d1357cdb0e6302db090b0bc4a0ab4caaf"
    sha256 cellar: :any,                 big_sur:        "3321efde4d390e09f47f9e6dc8f9781a24b0e4c4bb3b8da73579b0480deb1e92"
    sha256 cellar: :any,                 catalina:       "0a18647cdfd99d6fe2390ec5c4b38120489b524f51249ab102d9fe54e73036e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8f207bfeb7d60371a858cfb1e23961ae674d3dd6236d9db1bdf9476187e5f20"
  end

  depends_on "cmake" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libidn"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl@3"

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
    # C++ standard settings may be implemented upstream in which case the below will not be necessary.
    # See https://sourceforge.net/p/podofo/tickets/121/
    args += %w[
      -DCMAKE_CXX_STANDARD=11
      -DCMAKE_CXX_STANDARD_REQUIRED=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    assert_match "500 x 800 pts", shell_output("#{bin}/podofopdfinfo test.pdf")
  end
end
