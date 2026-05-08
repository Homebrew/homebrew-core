class Podofo < Formula
  desc "Library to work with the PDF file format"
  homepage "https://github.com/podofo/podofo"
  url "https://github.com/podofo/podofo/archive/refs/tags/1.1.0.tar.gz"
  sha256 "f34b4413b613e33ab9fe83ff5aa7e2827a6425fcbcd343339458d614b7d6a951"
  # TODO: in v1.1 check if LGPL-2.0-or-later can be removed by scanning SPDX-License-Identifier
  # https://github.com/podofo/podofo/blob/eb75c9f6d1b7b164f868433493c6560935cf981b/TODO.md
  # https://www.mail-archive.com/podofo-users@lists.sourceforge.net/msg05022.html
  license all_of: [
    "LGPL-2.0-or-later",
    { any_of: ["LGPL-2.0-or-later", "MPL-2.0"] },
    "GPL-2.0-or-later", # tools/

    # Additional licenses used in specific files
    "Apache-2.0", # src/podofo/private/FontUtils*
    "MIT",        # src/podofo/private/SASLprep*
    "OpenSSL",    # src/podofo/private/OpenSSLInternal_Ripped.cpp
  ]
  head "https://github.com/podofo/podofo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0d628a7b8ce12d2277c159bd65b4a78c21472c6fee2b2ae6b956aaadd4a23635"
    sha256 cellar: :any,                 arm64_sequoia: "0e724b4940581265d4a3c6abaed093accd3e3c0bbbcb79b04fa04feea8fa4290"
    sha256 cellar: :any,                 arm64_sonoma:  "eb359eccdba70fb8d4e5a055f04076323ec55809b773b464644abd39030e310d"
    sha256 cellar: :any,                 sonoma:        "95f03766fe17321d56805e4210bdd7c10d094981c07f60327e2cdb5b5f192fcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45fe13051bc05a001a633d3f3fe0bdcbd84aaf7d9fc084c8616457e7e66f573e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e826440973049706f57dc0bdaa02b473e3085a42fb33a5505fbdf9d514006a96"
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
