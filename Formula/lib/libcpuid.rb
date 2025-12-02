class Libcpuid < Formula
  desc "Small C library for x86 CPU detection and feature extraction"
  homepage "https://github.com/anrieff/libcpuid"
  url "https://github.com/anrieff/libcpuid/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "81f2f40da5d66b8220476e116cb40bca4e6a62c0d22bdeeb8e3856cf14607007"
  license "BSD-2-Clause"
  head "https://github.com/anrieff/libcpuid.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 sonoma:       "c1e23b9deee10397bca4e32933b1ba265ca04a9649d31a934b17ec561fa9b114"
    sha256 cellar: :any,                 ventura:      "08670c2e18ce4fb2fb021260ec3f5a32fbfc82842777cc52938dbf4914d14f17"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "dad70f4216aead591c3a9571f601adb46d251a21139beddce44c85a94a799cb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a8bedd7a2bb826cc95ae79026e65ba549cf476e6ce95fa3761e29e80cf6db710"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  on_macos do
    depends_on arch: :x86_64

    # Can be undeprecated if upstream decides to support arm64 macOS
    # https://docs.brew.sh/Support-Tiers#future-macos-support
    # TODO: Make linux-only when removing macOS support
    deprecate! date: "2025-09-25", because: :unsupported
    disable! date: "2026-09-25", because: :unsupported
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"cpuid_tool"
    assert_path_exists testpath/"raw.txt"
    assert_path_exists testpath/"report.txt"
    assert_match "CPUID is present", File.read(testpath/"report.txt")
  end
end
