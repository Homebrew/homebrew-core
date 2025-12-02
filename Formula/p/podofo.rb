class Podofo < Formula
  desc "Library to work with the PDF file format"
  homepage "https://github.com/podofo/podofo"
  url "https://github.com/podofo/podofo/archive/refs/tags/1.0.3.tar.gz"
  sha256 "02815b21a51632c2849d41b067597e9356bbc54bad0efcd84c902b555c203ce7"
  license all_of: ["LGPL-2.0-only", "GPL-2.0-only"]
  head "https://github.com/podofo/podofo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7d392f6365b35254ed306291dec5492f0906dc4c649a9f25bed8c2a2896d46ba"
    sha256 cellar: :any,                 arm64_sequoia: "17ae73de90ee1fa537cadfd91ca0b0eb1fdb47da0ac96af2dfb1502d9b35a94b"
    sha256 cellar: :any,                 arm64_sonoma:  "1680689f073bb1763fd6fede40fb6fe6623fb7575135fba72d72e695cb588ee6"
    sha256 cellar: :any,                 sonoma:        "e48947350364ddf6ff7f62edbfc576423e689323f5867e04247a10f3adfd279a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddcfa3be237be6e97c7569bb3e44624975296a4f7ebaf8d06afe40053f7d28c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21f85126552f9abdff2f83e543aa9c56a56cd7725328ac32417f8d45fcf1a0c4"
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
