class Ctail < Formula
  desc "Tool for operating tail across large clusters of machines"
  homepage "https://github.com/pquerna/ctail"
  url "https://github.com/pquerna/ctail/archive/ctail-0.1.0.tar.gz"
  sha256 "864efb235a5d076167277c9f7812ad5678b477ff9a2e927549ffc19ed95fa911"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 monterey:     "be4aa07bfd921f4903112f0ff6dbccc979b86cae77cdd75fe4ae9e2bcb3ff101"
    sha256 cellar: :any,                 big_sur:      "31c851cee6019ade6def5da7a50b2d901d04e1038d9d01d6985ac57a700a810f"
    sha256 cellar: :any,                 catalina:     "0821eb3a9bf969519149b7cb3038db2dc25836bc335c057e0ff263aa5fc2f7b2"
    sha256 cellar: :any,                 mojave:       "d81e805d4a80fd83b36fa579dff3c71a364b7bbc50ff6addf74a0d3790a92643"
    sha256 cellar: :any,                 high_sierra:  "de6e121995f86ec3dbfddf8bee861d9389c548648316f4901cbde691ca26a8d5"
    sha256 cellar: :any,                 sierra:       "829ed2ea1ac94bf32fd1817f714b87301abf2c488cf151675239d5d9bf6f6ef8"
    sha256 cellar: :any,                 el_capitan:   "80a2ae43fba99e6eb5eb4b50b52ee0e32213d521f59e147a109444439b86365d"
    sha256 cellar: :any,                 yosemite:     "e23b4f67bc165d9d4549963b41b9ee89a5fa2e18040277750c4800da016a919e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "583c009e46c529593648a48442ba5544aa1ac7ebb3cf1309c2e1eb08ed9f9439"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "apr"
  depends_on "apr-util"

  conflicts_with "byobu", because: "both install `ctail` binaries"

  def install
    system "./configure",
        "--prefix=#{prefix}",
        "--disable-debug",
        "--with-apr=#{Formula["apr"].opt_bin}",
        "--with-apr-util=#{Formula["apr-util"].opt_bin}"
    system "make", "LIBTOOL=glibtool --tag=CC"
    system "make", "install"
  end

  test do
    system "#{bin}/ctail", "-h"
  end
end
