class Pari < Formula
  desc "Computer algebra system designed for fast computations in number theory"
  homepage "https://pari.math.u-bordeaux.fr/"
  url "https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.9.2.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/p/pari/pari_2.9.2.orig.tar.gz"
  sha256 "9aa24cbbcf4e0b09dcc21cf9b09f2eb08e38ee16ab13651be7274c9b3e46207e"

  bottle do
    sha256 "e2708ec11078a54cad2991356a4fed959afb1fdb4b2a58bea5debcd1c729a93e" => :sierra
    sha256 "d97c361da5c314a298eff855bd7a30d87cffa6b1ac222dc30200ef652aa3a183" => :el_capitan
    sha256 "f660e2526e6a5103bcb5a3c5dc99ab6a8af51399a63285df9fe503cf82727076" => :yosemite
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
