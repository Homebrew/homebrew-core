class Pari < Formula
  desc "Computer algebra system designed for fast computations in number theory"
  homepage "https://pari.math.u-bordeaux.fr/"
  url "https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.11.0.tar.gz"
  sha256 "3835caccaa3e0c64764521032d89efeb8773cce841f6655fec6d58e790f4c9a1"

  bottle do
    sha256 "c8e1e3c1da64c35a7ecb8696e4cf31113112887fff6f1b16a193900f50ac73e6" => :high_sierra
    sha256 "1ae613ef98c71ce691906dc7cf5282374bfa18cc669e8570b77152648bc3d8c7" => :sierra
    sha256 "b5426e62d5db7181898d371c444889127e6e7a9336b40020ca65d51cb0f55006" => :el_capitan
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
