class Podofo < Formula
  desc "Library to work with the PDF file format"
  homepage "https://podofo.sourceforge.io"
  url "https://downloads.sourceforge.net/project/podofo/podofo/0.9.7/podofo-0.9.7.tar.gz"
  sha256 "7cf2e716daaef89647c54ffcd08940492fd40c385ef040ce7529396bfadc1eb8"
  license all_of: ["LGPL-2.0-only", "GPL-2.0-only"]
  head "svn://svn.code.sf.net/p/podofo/code/podofo/trunk"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "255cf94f4a6c121a443daf166bb604515134fdc49cbe397246363efa7b196310"
    sha256 cellar: :any,                 arm64_big_sur:  "3e52626a449c28973ad35209a5ce61969742879f1f88fe9cad56b4a93add49a1"
    sha256 cellar: :any,                 monterey:       "8d4025cd6338c2d6f4b5d0f2801f0c667072ef64cef470a6323f3ca276fdedfb"
    sha256 cellar: :any,                 big_sur:        "f9078444b3bfc33019cc26e01e07d636522553d51e3b415ebf16516f7802f08f"
    sha256 cellar: :any,                 catalina:       "845cb7626c32ac0b2202acb6f2c42313b210b1bf281afabeec41292a86bca92c"
    sha256 cellar: :any,                 mojave:         "f7e69aa8d5061863c85a0f5208781a8f42f31e38add04136cb9987a8c3477da9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0521b30dffbb805f3fcbb42e96e67c78bf114741b5b4d91badd5c10f86d99513"
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
    # C++ standard settings may be implemented upstream in which case the below will not be necessary.
    # See https://sourceforge.net/p/podofo/tickets/121/
    args += %w[
      -DCMAKE_CXX_STANDARD=11
      -DCMAKE_CXX_STANDARD_REQUIRED=ON
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
