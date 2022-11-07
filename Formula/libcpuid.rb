class Libcpuid < Formula
  desc "Small C library for x86 CPU detection and feature extraction"
  homepage "https://github.com/anrieff/libcpuid"
  url "https://github.com/anrieff/libcpuid/archive/v0.6.0.tar.gz"
  sha256 "202f334e29c46f45a0a54c9209e04816f2a703fdeefdd9b18acc119589d6eafa"
  license "BSD-2-Clause"
  head "https://github.com/anrieff/libcpuid.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 monterey:     "10ee187d9e292dac42be9924bf2b5ea2f495267335e5e5a56a35779d28ff3036"
    sha256 cellar: :any,                 big_sur:      "f7252b191ada11eee6bb25649cba4fda28be44c91ebcfd936e3508d3573bf4f1"
    sha256 cellar: :any,                 catalina:     "e954e21a3bb2ab10c1eb831af1626ccf9cbbe69e123a4da6d69975d59cfca867"
    sha256 cellar: :any,                 mojave:       "9cb4e35df56ce25adcfc4c0a03f1a377aac54ec7e217bc9bb583df41eebcc8c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "20afc15713aa6f9097f50da5ea44d06beda67451c70c52639d9bb973c0f5d26f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  # libcpuid is x86 tool
  depends_on arch: :x86_64

  def install
    system "autoreconf", "-ivf"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "Alder Lake-S", shell_output("#{bin}/cpuid_tool --cpulist 2>&1")

    system bin/"cpuid_tool", "--outfile=report.txt", "--report"
    assert_match "CPUID is present", (testpath/"report.txt").read

    assert_match version.to_s, shell_output("#{bin}/cpuid_tool --version")
  end
end
