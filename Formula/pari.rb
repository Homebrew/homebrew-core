class Pari < Formula
  desc "Computer algebra system designed for fast computations in number theory"
  homepage "https://pari.math.u-bordeaux.fr/"
  url "https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.11.4.tar.gz"
  sha256 "bfc88fc4f7352f4840e6e352c72f0369cbea8a45403b1834a6269f3709970b1c"
  license "GPL-2.0"

  bottle do
    sha256 "34bff086dc53fc97511828c3329f71ab67c394011f88d551dc5d820fad455a93" => :catalina
    sha256 "bb2a09ef34d5e55b7f357169c34cd8e5942bb074770b789757e21388d440d80d" => :mojave
    sha256 "13613061281235cc2ffb502fd6541775a305ab61aa6ff85ed8ca15b23ec44ae4" => :high_sierra
  end

  depends_on "gmp"
  depends_on "readline"

  def install
    readline = Formula["readline"].opt_prefix
    gmp = Formula["gmp"].opt_prefix
    system "./Configure", "--prefix=#{prefix}",
                          "--with-gmp=#{gmp}",
                          "--with-readline=#{readline}",
                          "--graphic=ps"
    # make needs to be done in two steps
    system "make", "all"
    system "make", "install"

    # Avoid references to Homebrew shims
    inreplace lib/"pari/pari.cfg", HOMEBREW_LIBRARY/"Homebrew/shims/mac/super/", "/usr/bin/"
  end

  def caveats
    <<~EOS
      If you need the graphical plotting functions you need to install X11 with:
        brew cask install xquartz
    EOS
  end

  test do
    (testpath/"math.tex").write "$k_{n+1} = n^2 + k_n^2 - k_{n-1}$"
    system bin/"tex2mail", testpath/"math.tex"
  end
end
