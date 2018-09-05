class Ctail < Formula
  desc "Tool for operating tail across large clusters of machines"
  homepage "https://github.com/pquerna/ctail"
  url "https://github.com/pquerna/ctail/archive/ctail-0.1.0.tar.gz"
  sha256 "864efb235a5d076167277c9f7812ad5678b477ff9a2e927549ffc19ed95fa911"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d81e805d4a80fd83b36fa579dff3c71a364b7bbc50ff6addf74a0d3790a92643" => :mojave
    sha256 "de6e121995f86ec3dbfddf8bee861d9389c548648316f4901cbde691ca26a8d5" => :high_sierra
    sha256 "829ed2ea1ac94bf32fd1817f714b87301abf2c488cf151675239d5d9bf6f6ef8" => :sierra
    sha256 "80a2ae43fba99e6eb5eb4b50b52ee0e32213d521f59e147a109444439b86365d" => :el_capitan
    sha256 "e23b4f67bc165d9d4549963b41b9ee89a5fa2e18040277750c4800da016a919e" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "apr"
  depends_on "apr-util"

  conflicts_with "byobu", :because => "both install `ctail` binaries"

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
