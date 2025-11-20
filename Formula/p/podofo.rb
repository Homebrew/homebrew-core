class Podofo < Formula
  desc "Library to work with the PDF file format"
  homepage "https://github.com/podofo/podofo"
  url "https://github.com/podofo/podofo/archive/refs/tags/1.0.2.tar.gz"
  sha256 "4f46edac16e0b3badba2e972b3e3b7d8381845fad3eb39a02562cb7a04207d45"
  license all_of: ["LGPL-2.0-only", "GPL-2.0-only"]
  revision 1
  head "https://github.com/podofo/podofo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b2ede0bb36c3b39bbd826f2dcc6839c51d670d4384a5fe29b7e0f01158a29122"
    sha256 cellar: :any,                 arm64_sequoia: "366bba6682bf44d25287746fee42cbf2681d3f29e288814ee6fce5e83a046fb3"
    sha256 cellar: :any,                 arm64_sonoma:  "0d8700373b6887e4907eda39021308a10744b838b9ecec6e5e2849b501900c4d"
    sha256 cellar: :any,                 sonoma:        "b0ba3e2db8230e2d7906710b5c7647b72ecb4076eb5096383f473354bb5757e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "473e71fd94c3eece308f21527168da7e78d776c4cb164aea987d81d545544596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "256c8a39e4debe49299776dac6661a0eca9b0fa679ab0ae8af8249890baaf16d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl@3"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_ventura :or_older do
    depends_on "llvm"

    fails_with :clang do
      cause "error: 'to_chars' is unavailable: introduced in macOS 13.3"
    end
  end

  def install
    if OS.mac? && MacOS.version <= :ventura
      ENV.llvm_clang
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
