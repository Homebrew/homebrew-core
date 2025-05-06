class Libcpuid < Formula
  desc "Small C library for x86 CPU detection and feature extraction"
  homepage "https://github.com/anrieff/libcpuid"
  url "https://github.com/anrieff/libcpuid/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "a5fe37d79bda121cbdf385ae3f6fa621da6a3102aa609400a718a4b8b82ed8aa"
  license "BSD-2-Clause"
  head "https://github.com/anrieff/libcpuid.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 sonoma:       "a96631f0f039e5fbdac221e14ee15515a85e07cb0244e8bb975f97661fbf7c95"
    sha256 cellar: :any,                 ventura:      "aeed3eaa6c57348a2e14f9889c933e08623b446a84090a2c91a9d78f6a700d9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "cbfd10fe0ec68c63934be68907409b761eeabadfdbc36903e9eb85fcfdaf2b15"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "abd065dd786dcd3f4c4343f418e810502bdebf0674b0f01a05f58c06d98fd4e1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  on_macos do
    depends_on arch: :x86_64
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
