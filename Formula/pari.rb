class Pari < Formula
  desc "Computer algebra system designed for fast computations in number theory"
  homepage "https://pari.math.u-bordeaux.fr/"
  url "https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.13.1.tar.gz"
  sha256 "81ecf7d70ccdaae230165cff627c9ce2ec297b8f22f9f40742279d85f86dfcb1"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://pari.math.u-bordeaux.fr/pub/pari/unix/"
    regex(/pari[._-]v?(\d+\.\d+\.\d+)/i)
  end

  bottle do
    sha256 "7ace3e8f2f47e1c88afb201ba7ac04d3b8256087a35ef54d87fc8c7b360bbe07" => :big_sur
    sha256 "7e796de25f4a878b1032feef8d20d5f149e5dd303c6601b8f25e79e29a2a358b" => :arm64_big_sur
    sha256 "1394ad170419cc2002f364bdf3ec579823ca259ec4e082f225fcff3d52b1bde9" => :catalina
    sha256 "ab722c114214113c867f878cf7016d67f2d0dea2cc6e1526e8924fc5b5fb21cd" => :mojave
    sha256 "c0e5508356c5cc200b5085c4e46a3bb233cf02e6146ebe4eeaf1abc5b0af071b" => :high_sierra
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
        brew install --cask xquartz
    EOS
  end

  test do
    (testpath/"math.tex").write "$k_{n+1} = n^2 + k_n^2 - k_{n-1}$"
    system bin/"tex2mail", testpath/"math.tex"
  end
end
