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
    sha256 cellar: :any,                 arm64_sequoia: "746fab5e13fff37b542e22aa312460ef0a7f682d0753451860f10b749543ad08"
    sha256 cellar: :any,                 arm64_sonoma:  "f8c140ea8d95f9c79d1d8b0c779e2f8a42a668f2b9a1405d3c964b7bf7904abf"
    sha256 cellar: :any,                 arm64_ventura: "8cf0efc5f48abb1287f0c51f8fba04507fea0243a3b0e079ce584e96254a5f3e"
    sha256 cellar: :any,                 sonoma:        "3f2dbdff549ecf6aebc768cd6acd3364d9451b1d6bb3a26d7f8feb381b52a164"
    sha256 cellar: :any,                 ventura:       "4985f589d79001c1a6fbcf4783f77cfcc0902fa93dd42b7ee5827d046df820be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "558bd4ab20e1971706cf525638d2706166d3ae9e5fa2b6338f8c38f168621a53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fbc9e09e5bee79e8fefd31fa9bfed573bb22e2241c3eb4dac467fcbbf76b6a0"
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
