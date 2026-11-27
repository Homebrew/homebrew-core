class Podofo < Formula
  desc "Library to work with the PDF file format"
  homepage "https://github.com/podofo/podofo"
  url "https://github.com/podofo/podofo/archive/refs/tags/1.1.3.tar.gz"
  sha256 "9fe13b87148cd9691dc7f5b40dca9ce789576c131fe65e90a09e163a4fb25c31"
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
    manifest_sha256 "b2a0341d2b7f140a3ad496fd2502d0f081e7215ee985ac8a6d7b16cc4b3f8415"
    sha256 cellar: :any, arm64_golden_gate: "9e11b51e2e308ca45fb0c483d8adbaaf8272043bb7bd631c12762e92494ce977"
    sha256 cellar: :any, arm64_tahoe:       "f22d4674d26b4f003513bd2a6e44567e71cd0645f356defffe5d71ed03da07d2"
    sha256 cellar: :any, arm64_sequoia:     "369f6c7df2f1be6a619ca173743da48a3a80522de1fe12908d26c6e9641d1b83"
    sha256 cellar: :any, arm64_linux:       "b078619aafb24a3a58c73d02df87614bcc0725db98b6b124ecf670626cb585a8"
    sha256 cellar: :any, x86_64_linux:      "09772d6811fd33b614e42a5a80b9a13bff7add415117f311b13fd7e50051639a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl@4"

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

  deny_network_access!

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
