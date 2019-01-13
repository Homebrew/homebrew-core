class Pari < Formula
  desc "Computer algebra system designed for fast computations in number theory"
  homepage "https://pari.math.u-bordeaux.fr/"
  url "https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.11.0.tar.gz"
  sha256 "3835caccaa3e0c64764521032d89efeb8773cce841f6655fec6d58e790f4c9a1"
  revision 1

  bottle do
    sha256 "132614e46066837aa3d3a4661bbbcdc648dbb48ba1835873a58f54b8805d31f1" => :mojave
    sha256 "0bca55f59df6cb9441bc5b49140392a089df20ec85d08452ca7966f395d71a73" => :high_sierra
    sha256 "2f8f44aeaa83bf1ba107946b82b81e032305afd6db5d02b10a6027afb902c862" => :sierra
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
