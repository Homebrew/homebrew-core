class Podofo < Formula
  desc "Library to work with the PDF file format"
  homepage "https://github.com/podofo/podofo"
  url "https://github.com/podofo/podofo/archive/refs/tags/0.10.3.tar.gz"
  sha256 "4be2232643f9e9dd7fbb02894d5a0394c3ca2826aab179654c2cc751074825ec"
  license all_of: ["LGPL-2.0-only", "GPL-2.0-only"]
  head "https://github.com/podofo/podofo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "6916059ce58b1016b37a5e00880919eb613d350ee0429b64240d93223b00e167"
    sha256 cellar: :any,                 arm64_ventura:  "723be940f3ab2d03693a4892e78cc9cfb1b90fdc2b1d6c9450dbe0ae8b7da6ec"
    sha256 cellar: :any,                 arm64_monterey: "86fcbad492a3a82a3d9c1fb29f76bd5104dfd056593b6a03caeeee81a9abd888"
    sha256 cellar: :any,                 sonoma:         "8be022ca383754de73ccc7cfc75ebbd16986bd2cbafdc8d1bcbde651b343cf9e"
    sha256 cellar: :any,                 ventura:        "e8ee595be473003af4cb4c2f24997aff75b7f9f49fc1bf5c3d4c1422bdde3989"
    sha256 cellar: :any,                 monterey:       "3292798d1992a3921500dff564708ad39abd9b7650551619990a94a6af16455c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0d8758427d5f1db857a9924edb620f2f97c66e0a30ce3dbf28c7a3e1b6094af"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libidn"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl@3"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    args = %W[
      -DCMAKE_INSTALL_NAME_DIR=#{opt_lib}
      -DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_CppUnit=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_LUA=ON
      -DPODOFO_BUILD_TOOLS=TRUE
      -DFREETYPE_INCLUDE_DIR_FT2BUILD=#{Formula["freetype"].opt_include}/freetype2
      -DFREETYPE_INCLUDE_DIR_FTHEADER=#{Formula["freetype"].opt_include}/freetype2/config/
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    assert_match "500 x 800 pts", shell_output("#{bin}/podofopdfinfo test.pdf")
  end
end
