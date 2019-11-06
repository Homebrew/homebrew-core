class Liboping < Formula
  desc "C library to generate ICMP echo requests"
  homepage "https://noping.cc/"
  url "https://noping.cc/files/liboping-1.10.0.tar.bz2"
  sha256 "eb38aa93f93e8ab282d97e2582fbaea88b3f889a08cbc9dbf20059c3779d5cd8"

  bottle do
    sha256 "997e8eb17c7878cbd0c34bd6532b76ef804899751a58b3b434656d1b9ced07d9" => :catalina
    sha256 "7b0258598b329b83ce9fd0cf18be77aa027226c8391a013cb3699faeeb1fd71f" => :mojave
    sha256 "accffc91ab24ccba1214727abadb59c497f403e3bcad1dfe8ff0377d32e05ebc" => :high_sierra
    sha256 "42b80e23afe4fb4f296d039b0bdd4ccd0da21937514fdd04a90bc01d39da7aec" => :sierra
    sha256 "de0bb72a0752469b262db3a24a41c84746930858462cd08993c057caadd46264" => :el_capitan
    sha256 "c4f46d01bdace450a49e2c4fc4ba4056070bf1b869ed07f1b0a1d6a4f7646bc9" => :yosemite
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
