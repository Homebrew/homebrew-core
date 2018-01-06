class CrosstoolNg < Formula
  desc "Tool for building toolchains"
  homepage "http://crosstool-ng.org"
  url "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.23.0.tar.xz"
  sha256 "68a43ea98ccf9cb345cb6eec494a497b224fee24c882e8c14c6713afbbe79196"
  revision 1

  bottle do
    cellar :any
    sha256 "2e6df99ebde627f3ca8b8309724fb132baa749ddae237d4f4fc8b5e03f34c06c" => :high_sierra
    sha256 "bda4c02b605a79fa980bf8df055d3b9d1a7da01f4212a98ebc79a5ccc57649a3" => :sierra
    sha256 "67563525dbf2cc4a8cf60da1e398474609c1aa8f0ef3d8ac68d318064aba4c28" => :el_capitan
    sha256 "c119b94b8b4782935e7c2968d195cddcfd2faa089768c0a0bf84dfcb8d5713cc" => :yosemite
  end

  depends_on "help2man" => :build
  depends_on "autoconf" => :run
  depends_on "automake" => :run
  depends_on "libtool" => :run
  depends_on "binutils"
  depends_on "coreutils"
  depends_on "flex"
  depends_on "gawk"
  depends_on "gnu-sed"
  depends_on "grep"
  depends_on "m4"
  depends_on "xz"

  def install
    ENV["M4"] = "#{Formula["m4"].opt_bin}/m4"
    ENV["MAKE"] = "/usr/bin/make" # prevent hardcoding make path from superenv

    system "./configure", "--prefix=#{prefix}"

    # Must be done in two steps
    system "make"
    system "make", "install"
  end

  test do
    assert_match "This is crosstool-NG", shell_output("make -rf #{bin}/ct-ng version")
  end
end
