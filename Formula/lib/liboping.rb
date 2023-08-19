class Liboping < Formula
  desc "C library to generate ICMP echo requests"
  homepage "https://noping.cc/"
  url "https://noping.cc/files/liboping-1.10.0.tar.bz2"
  sha256 "eb38aa93f93e8ab282d97e2582fbaea88b3f889a08cbc9dbf20059c3779d5cd8"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?liboping[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4f96385d085c835f78741e71350fba8666a9692673abab3681722f7dc22fef1f"
    sha256 cellar: :any,                 arm64_monterey: "88e26997cd417b2be6c8323451267524135044c033e6c34772cf9dc7812d9d4f"
    sha256                               arm64_big_sur:  "a8ea63333bfc0a7ec880d0c5727316ff622ff2f4854efc93bd9bc082080f9365"
    sha256 cellar: :any,                 ventura:        "8866dff120426703941ef3eff9e6253c9ed14fde9181dc4a65207599926d973a"
    sha256 cellar: :any,                 monterey:       "0e71715fba4fca28f5488409e5529ac61b7f166cea4cc2180967cc4d9a50dda6"
    sha256                               big_sur:        "0edb72c3d81dbc8869b28d27f063372f7eed0ac4318624fe94e4ac5be7d2337a"
    sha256                               catalina:       "997e8eb17c7878cbd0c34bd6532b76ef804899751a58b3b434656d1b9ced07d9"
    sha256                               mojave:         "7b0258598b329b83ce9fd0cf18be77aa027226c8391a013cb3699faeeb1fd71f"
    sha256                               high_sierra:    "accffc91ab24ccba1214727abadb59c497f403e3bcad1dfe8ff0377d32e05ebc"
    sha256                               sierra:         "42b80e23afe4fb4f296d039b0bdd4ccd0da21937514fdd04a90bc01d39da7aec"
    sha256                               el_capitan:     "de0bb72a0752469b262db3a24a41c84746930858462cd08993c057caadd46264"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f3979a8a214b2384b5c18cb7ad0d1ed49d27896b7972a2ce93dce2e0d76ad82"
  end

  uses_from_macos "ncurses"
  uses_from_macos "perl"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    "Run oping and noping sudo'ed in order to avoid the 'Operation not permitted'"
  end

  test do
    system bin/"oping", "-h"
    system bin/"noping", "-h"
  end
end
