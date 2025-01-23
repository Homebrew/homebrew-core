class Libcpuid < Formula
  desc "Small C library for x86 CPU detection and feature extraction"
  homepage "https://github.com/anrieff/libcpuid"
  url "https://github.com/anrieff/libcpuid/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "c54879ea33b68a2e752c20fb0e3cd04439a9177eab23371f709f15a45df43644"
  license "BSD-2-Clause"
  head "https://github.com/anrieff/libcpuid.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 sonoma:       "502f564bd91523e79b8506f8bf753efcbe86bf85b047b197c92a3a1232b17f02"
    sha256 cellar: :any,                 ventura:      "1dcb0552126da1472e9c6cd0abc3a4231c255a6e474d16fb07983efac34a3e44"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bd7e4e542360e3fd3e343512b328bbdb95790c08043f5bae000af293b74929ef"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on arch: :x86_64

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"cpuid_tool"
    assert_predicate testpath/"raw.txt", :exist?
    assert_predicate testpath/"report.txt", :exist?
    assert_match "CPUID is present", File.read(testpath/"report.txt")
  end
end
