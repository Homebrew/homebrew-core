class Podofo < Formula
  desc "Library to work with the PDF file format"
  homepage "https://github.com/podofo/podofo"
  url "https://github.com/podofo/podofo/archive/refs/tags/1.0.0.tar.gz"
  sha256 "e44276d927838034b51c4c79001e7ae5c3fef90b6844824004c77f160c1a22ea"
  license all_of: ["LGPL-2.0-only", "GPL-2.0-only"]
  head "https://github.com/podofo/podofo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7c435c43229584af3a6dacf57822271969610de7507f61397b457afb83145d13"
    sha256 cellar: :any,                 arm64_sonoma:  "021956f2a96a9661ce424e048a17c70f4e01a117eccdcf161e8d770122ec5fdf"
    sha256 cellar: :any,                 arm64_ventura: "6efa2ab68a3d25d65c43adf0ff70d5ecfd3c2d2c132f7ab491225842992335a7"
    sha256 cellar: :any,                 sonoma:        "5de8cfae5cf79354203b9a6a4138d0aeee038feb186430f9d2bc1a3b94329d75"
    sha256 cellar: :any,                 ventura:       "8d58c3e164bce391cf4fe8ad987b2d81a79bf2f4f40dde4f0c9b1137ebaa9a4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f46f50ea998e67693cbb46550684b3845902f6c985765ade57e21e207173f45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b850c51ef8df89ab04d0c37364bf7e20a91d7f30c7be86c474141be7add8be52"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libidn"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl@3"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_ventura :or_older do
    depends_on "llvm" => :build

    fails_with :clang do
      cause "error: 'to_chars' is unavailable: introduced in macOS 13.3"
    end
  end

  def install
    if OS.mac? && MacOS.version <= :ventura
      ENV.llvm_clang
      ENV.append "LDFLAGS", "-L#{Formula["llvm"].opt_lib}/unwind -lunwind"
      # When using Homebrew's superenv shims, we need to use HOMEBREW_LIBRARY_PATHS
      # rather than LDFLAGS for libc++ in order to correctly link to LLVM's libc++.
      ENV.prepend_path "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib/"c++"
      # Workaround for error: call to 'from_chars' is ambiguous
      inreplace "src/podofo/private/charconv_compat.h", "#define WANT_FROM_CHARS", ""
    end

    args = %W[
      -DCMAKE_INSTALL_NAME_DIR=#{opt_lib}
      -DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON
      -DPODOFO_BUILD_UNSUPPORTED_TOOLS=TRUE
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
