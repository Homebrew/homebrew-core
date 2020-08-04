class Libcpuid < Formula
  desc "Small C library for x86 CPU detection and feature extraction"
  homepage "https://github.com/anrieff/libcpuid"
  url "https://github.com/anrieff/libcpuid/archive/v0.5.0.tar.gz"
  sha256 "49893f31475510aa0ebe2ad3a29fad95e2a592cc5f48451c95271c536f89a157"
  license "BSD-2-Clause"
  head "https://github.com/anrieff/libcpuid.git"

  bottle do
    cellar :any
    sha256 "df477785b9f155d2ed62f8d9213301bbfe32235f2337eff3e1d549bec2f92a7a" => :catalina
    sha256 "cad37d2a433cab21c1776b0815efa0dba907c31444d81c7770f27df296ff9cd9" => :mojave
    sha256 "e1370567a0f5ea7504d2f254a1b375006a19f6b68a5948fb4d51febfdfd194cc" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"cpuid_tool"
    assert_predicate testpath/"raw.txt", :exist?
    assert_predicate testpath/"report.txt", :exist?
    assert_match "CPUID is present", File.read(testpath/"report.txt")
  end
end
