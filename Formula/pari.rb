class Pari < Formula
  desc "Computer algebra system designed for fast computations in number theory"
  homepage "https://pari.math.u-bordeaux.fr/"
  url "https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.11.0.tar.gz"
  sha256 "3835caccaa3e0c64764521032d89efeb8773cce841f6655fec6d58e790f4c9a1"

  bottle do
    sha256 "62dd478f21d266b95bc7ef62a1cefbb760416540fa9ad4c481dab4160c61f6ae" => :mojave
    sha256 "695ad213a9fbb81ca3ae948b5b597f5bd992e4f016fd04631aa031f455a2a218" => :high_sierra
    sha256 "5763ae6604f64710145363b7eaf3e6a2c14f759f05329222da4ef973da1ceeed" => :sierra
    sha256 "0445d9d8f3cfe90c13ed276b869b847667a4e610dc99477f02e4af356c02eff7" => :el_capitan
  end

  depends_on "gmp"
  depends_on "readline"
  depends_on :x11

  def install
    readline = Formula["readline"].opt_prefix
    gmp = Formula["gmp"].opt_prefix
    system "./Configure", "--prefix=#{prefix}",
                          "--with-gmp=#{gmp}",
                          "--with-readline=#{readline}"
    # make needs to be done in two steps
    system "make", "all"
    system "make", "install"
  end

  test do
    (testpath/"math.tex").write "$k_{n+1} = n^2 + k_n^2 - k_{n-1}$"
    system bin/"tex2mail", testpath/"math.tex"
  end
end
