class Podofo < Formula
  desc "Library to work with the PDF file format"
  homepage "https://github.com/podofo/podofo"
  url "https://github.com/podofo/podofo/archive/refs/tags/1.1.2.tar.gz"
  sha256 "d6ffe6fc173ac6d6e5b00f5cb9db01990cab1bdf7cc03bdeffce3013bc9ec63a"
  license all_of: [
    { any_of: ["LGPL-2.0-or-later", "MPL-2.0"] },
    "GPL-2.0-or-later", # tools/

    # Additional licenses used in specific files
    "Apache-2.0", # src/podofo/private/FontUtils*
    "MIT",        # src/podofo/private/SASLprep*
    any_of: [     # src/podofo/private/OpenSSLInternal*
      { "LGPL-2.0-or-later" => { with: "cryptsetup-OpenSSL-exception" } },
      "MPL-2.0",
    ],
  ]
  head "https://github.com/podofo/podofo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1a7b951f6e9d553a2958ed922fd18d08b13a24e429b82820d19ce13787819b7c"
    sha256 cellar: :any, arm64_sequoia: "0ac2ef3c796d651a47ac64e0b4125b2a3fe1b7d286c1b722f8700145b3bf569b"
    sha256 cellar: :any, arm64_sonoma:  "6e20f51323ed0c344798ef7f14333b8ec66730d93ce5a7a4d3e77b59e4a3a38f"
    sha256 cellar: :any, sonoma:        "9c0338f3168227a7c7d5efe212c4333b72f169937e42006903f3b0c0aa8a695d"
    sha256 cellar: :any, arm64_linux:   "87ce69276e48983f3e63b968fc2b29bca490735691c090467a5d72209a59ac63"
    sha256 cellar: :any, x86_64_linux:  "e5eb97711f90edd3eb9a85e450010aafcdedc5259912d69f235c3fb9cbf8bd05"
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

  on_ventura :or_older do
    depends_on "llvm"

    fails_with :clang do
      cause "error: 'to_chars' is unavailable: introduced in macOS 13.3"
    end
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    if OS.mac? && MacOS.version <= :ventura
      # When using Homebrew's superenv shims, we need to use HOMEBREW_LIBRARY_PATHS
      # rather than LDFLAGS for libc++ in order to correctly link to LLVM's libc++.
      ENV.prepend_path "HOMEBREW_LIBRARY_PATHS", formula_opt_lib("llvm")/"c++"
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
