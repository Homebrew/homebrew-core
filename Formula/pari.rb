class Pari < Formula
  desc "Computer algebra system designed for fast computations in number theory"
  homepage "https://pari.math.u-bordeaux.fr/"
  url "https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.9.2.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/p/pari/pari_2.9.2.orig.tar.gz"
  sha256 "9aa24cbbcf4e0b09dcc21cf9b09f2eb08e38ee16ab13651be7274c9b3e46207e"

  bottle do
    sha256 "706967276bb148178350324b1e9f625cb23fdb8e2a7fd75a152e6732227fd0e9" => :sierra
    sha256 "fd27fd3766613d457c720e680567e0a89098263d2c6c9bb12ec290b7ec993ec1" => :el_capitan
    sha256 "5cd57835aa5ac9c738146f30f0f4d04e0d00685d080cdb4cd82932d551033941" => :yosemite
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
