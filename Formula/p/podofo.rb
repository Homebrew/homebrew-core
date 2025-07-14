class Podofo < Formula
  desc "Library to work with the PDF file format"
  homepage "https://github.com/podofo/podofo"
  url "https://github.com/podofo/podofo/archive/refs/tags/1.0.1.tar.gz"
  sha256 "951ba6d2f5083650b8ebc959d66a232e15ea43b7c737230cedf23ed163f5051f"
  license all_of: ["LGPL-2.0-only", "GPL-2.0-only"]
  head "https://github.com/podofo/podofo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4debfbd98658b333548a51fefe441891a5713a5d927d339b9fe46a23e8f18556"
    sha256 cellar: :any,                 arm64_sonoma:  "c156ce176e34b54866bb1372f733b7f9290cd09e8ad96edf9fbd4cb2fe0c8faf"
    sha256 cellar: :any,                 arm64_ventura: "fffe5ed348def5cb2de2bf6b9fd76d0d91472c67b2d2269809b1edd9c6eedb5b"
    sha256 cellar: :any,                 sonoma:        "144715ffc6d38626db71fb922435ad32ca3dc40479e70fb5d377cc570d263fab"
    sha256 cellar: :any,                 ventura:       "ef570ef6ade873ecf77c248349084827a36b81324c088fa01d61475c44a445e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbb6ba74be61c02d7f94b2ba9b1aa88f0360667b2fca0bcd55e2887c7cb6bb36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "250317e562b5021279d51e06624a7ed8904ffd4108bec934d1b199d4ea912ffa"
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
