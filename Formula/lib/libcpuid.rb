class Libcpuid < Formula
  desc "Small C library for x86 CPU detection and feature extraction"
  homepage "https://github.com/anrieff/libcpuid"
  url "https://github.com/anrieff/libcpuid/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "4d106d66d211f2bfaf876eb62c84d4b54664e1c2b47eb6138161d3c608c0bc5e"
  license "BSD-2-Clause"
  head "https://github.com/anrieff/libcpuid.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 sonoma:       "1367e57c41df159f9c1145f395a909e6ad7b414005ed4ba04b9a0bf11a7777da"
    sha256 cellar: :any,                 ventura:      "e0893076098538b39f1cb35529fdb93fae864be2641906f75e225922093bbbdb"
    sha256 cellar: :any,                 monterey:     "48ef828a48e9ad86e5c69b7e606b4752771b1b0acbebd2e675cdfb62abf93a79"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6957930f517ed96cee54023d493d4448e3b74a783ae9bc7f5b1804eab4fc9064"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on arch: :x86_64

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
