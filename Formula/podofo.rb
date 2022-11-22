class Podofo < Formula
  desc "Library to work with the PDF file format"
  homepage "https://podofo.sourceforge.io"
  url "https://downloads.sourceforge.net/project/podofo/podofo/0.9.8/podofo-0.9.8.tar.gz"
  sha256 "5de607e15f192b8ad90738300759d88dea0f5ccdce3bf00048a0c932bc645154"
  license all_of: ["LGPL-2.0-only", "GPL-2.0-only"]
  revision 1
  head "svn://svn.code.sf.net/p/podofo/code/podofo/trunk"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "85846bbe1ffd8c425174f29a50fe278d17ec7561f9c73afffcb7aa25035a40a8"
    sha256 cellar: :any,                 arm64_monterey: "3f6f31c67de44012c99d67c8fd199a365f2482b4e6f5a2cf3ec835c3f16b148c"
    sha256 cellar: :any,                 arm64_big_sur:  "c0173e0e2f363efe2f03aaef8677310f52f994966f3665814ca0dedaddd78d36"
    sha256 cellar: :any,                 ventura:        "68ff0b120ed6e8cc5e493e0fb1fc07b7cbfb877b550b153036de612e9091782b"
    sha256 cellar: :any,                 monterey:       "db9da10d40210749d99357f95176c5a1a5766c703262094af6b030f5e670de3f"
    sha256 cellar: :any,                 big_sur:        "e16ce776142f7f2da35b549805c0a49e2a61f40b95b0a73357061440373ac0b5"
    sha256 cellar: :any,                 catalina:       "0ff7fc07f1044393eb33ef3da8c0ac2f4eeda765e32172dfcf4def7818e08fe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c27f3f2155a17424c12477cb8e084485f141a7d1b903b7a46a94e6e6253caa3d"
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
