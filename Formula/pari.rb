class Pari < Formula
  desc "Computer algebra system designed for fast computations in number theory"
  homepage "https://pari.math.u-bordeaux.fr/"
  url "https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.9.3.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/p/pari/pari_2.9.3.orig.tar.gz"
  sha256 "e76a27779d2b1210ce1aba48363b98dd201a1bf876eb14f46ea6bd7769a00a63"

  bottle do
    sha256 "277dfbdc1111f80998e37b26372cdc5f8492a76547651a8a1296b931ac23d915" => :sierra
    sha256 "b4b85de28303d7c0dd6bfb4199d5dc11648a5f119d142b71437939cf3c95db89" => :el_capitan
    sha256 "5eee87a9a209235e74a8c608e84228de425dc16c0a44bae6e22ab54e736bb752" => :yosemite
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
