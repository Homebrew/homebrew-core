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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "9a6e4ab30d6d9c3f4048d2e50af123295fe41aabf46f8cdf04fda16b80634f5b"
    sha256 cellar: :any,                 arm64_sequoia: "dc1910830503d893481807302ab276b8c7b6af2a2eb5f2b037a2fde24a6f869d"
    sha256 cellar: :any,                 arm64_sonoma:  "8af3bbe091cd5fcd623fd26fe720bbc4d43c2fd1d83d54ddbfd2b84b753788b5"
    sha256 cellar: :any,                 sonoma:        "1e8b850aa39280bcd77c5c008f2a40368155dc1010d7ec2bf02a17b8b3f1c24c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff0ffddeb53e9590f5ae388f4c33a79ff51b66604fa74f058b182d09b423006c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "312f1f9db2bb46c3de26b0062ea1316d641ecf47705c47f223ba99870eb37a96"
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
