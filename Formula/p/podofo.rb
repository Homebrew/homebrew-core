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
    sha256 cellar: :any,                 arm64_sonoma:   "18c42f4e349c7831ad1c88da9bcb6a3186bae96592a58bcc9564dfddeaa47a66"
    sha256 cellar: :any,                 arm64_ventura:  "8aa327cf0a9521152589c4f35e8c24d17ca81e6e9a0409a124c81ceae1adf36d"
    sha256 cellar: :any,                 arm64_monterey: "32eb565b522ee3d479f1f63e9c8734f0055723f15c0d40d1e5742a0e8c37deb3"
    sha256 cellar: :any,                 sonoma:         "6bc07e073418fdea964f84b51620d13c29a2b15891f8a2b66f7edad55270c9db"
    sha256 cellar: :any,                 ventura:        "eb9faea265097f17b3304901c77eb6c062dcf29a9e8de96423bca460ddb085f1"
    sha256 cellar: :any,                 monterey:       "121f760c5d73c7b343d4f6a828f8c9dc436991c167fb6ed2f7d40821f35913ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33fbbf5d0eba0905261b5cc12483dbd14f1c87a7b6b6fee90b3d3352bba3723f"
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
