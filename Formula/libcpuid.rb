class Libcpuid < Formula
  desc "Small C library for x86 CPU detection and feature extraction"
  homepage "https://github.com/anrieff/libcpuid"
  url "https://github.com/anrieff/libcpuid/archive/v0.6.3.tar.gz"
  sha256 "da570fdeb450634d84208f203487b2e00633eac505feda5845f6921e811644fc"
  license "BSD-2-Clause"
  head "https://github.com/anrieff/libcpuid.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 ventura:      "84d3564619410abf63cb5dd759bd5c129d9caf273ab972bc1f04ff4fa3fcb29a"
    sha256 cellar: :any,                 monterey:     "d05aefe01176128d788f2c914d02b8ffc6a111ef2c2e04d142a2c3f3fc46a68b"
    sha256 cellar: :any,                 big_sur:      "35cae66754dd499614f854c21da717fec919aaf7cfd50ea8e0a3c9b83e332a19"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "583ac04b1bd04fde3501f4f18fa0743f38f2302094f91369963b001349230343"
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
