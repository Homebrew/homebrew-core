class Podofo < Formula
  desc "Library to work with the PDF file format"
  homepage "https://github.com/podofo/podofo"
  url "https://github.com/podofo/podofo/archive/refs/tags/0.10.1.tar.gz"
  sha256 "9b2bb5d54185a547e440413ca2e9ec3ea9c522fec81dfeb9a23dbc3d65fbaa55"
  license all_of: ["LGPL-2.0-only", "GPL-2.0-only"]
  head "https://github.com/podofo/podofo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "57bb0c459a607efc63fffbf3fc441a31ff5429326048c661303d13f9c2578205"
    sha256 cellar: :any,                 arm64_monterey: "2b6116b1d99b7499367c66b449c18323258d9d63c248673d2671c078e4ac8cfc"
    sha256 cellar: :any,                 arm64_big_sur:  "2885c35de6a79655a3bd388f121bd4c85b16bba6bd26b431d08d0b404d5ccd6f"
    sha256 cellar: :any,                 ventura:        "e8d8ed810ea8911cbbdabf9fe0f5e881dd4753a10302f3f59336db42c5d2afd9"
    sha256 cellar: :any,                 monterey:       "7e6e8a4f4ca608bc9ecd7e656ef4d783d6dab07de01639d7c1f0088ba952cbb7"
    sha256 cellar: :any,                 big_sur:        "eef1a0c69311eec0cea327113d6135a5a4f91e1654daca0b9399b9dc7483c27c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57050d099ff592d3921c0c718aeb5f0f2af9fa79cd5ccc3adc0bc52199126cd3"
  end

  depends_on "cmake" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libidn"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl@3"

  uses_from_macos "libxml2"

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
