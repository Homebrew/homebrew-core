class Podofo < Formula
  desc "Library to work with the PDF file format"
  homepage "https://github.com/podofo/podofo"
  url "https://github.com/podofo/podofo/archive/refs/tags/1.0.2.tar.gz"
  sha256 "4f46edac16e0b3badba2e972b3e3b7d8381845fad3eb39a02562cb7a04207d45"
  license all_of: ["LGPL-2.0-only", "GPL-2.0-only"]
  head "https://github.com/podofo/podofo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "087debfaf5086a933deda3bd9178e3d5b7f094ad5e03bb2a4dccdcef42194273"
    sha256 cellar: :any,                 arm64_sequoia: "7355a7ea6cef2c5e2a9594fb743d9ac9f2be8fd88521e259467197ba1aeccfab"
    sha256 cellar: :any,                 arm64_sonoma:  "c8724b528af9b6c9002f30793a6fe1a0d1e95b72ed4757a1d0ddf24709a85f37"
    sha256 cellar: :any,                 arm64_ventura: "e94c577a3ee275ebc4c9b917441af055b91bae18aa9469916fc44ddd9fb7cc90"
    sha256 cellar: :any,                 sonoma:        "a4cb1de96cf8c928fe96293e051c41a81c6dd1de35ac0bd0f93abc806c3afe15"
    sha256 cellar: :any,                 ventura:       "d2ca3b3ed1d023f777971e46b535956bdc55172973cf296f241c057a95e068fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de028ffaf3cde82277c24a1d67897753bff5ea8659876db678a305231406d2d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be719e3165a2147327f15f9e338fcf218589c60c594df3455927be5e31868b73"
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
