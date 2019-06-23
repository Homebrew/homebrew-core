class Pari < Formula
  desc "Computer algebra system designed for fast computations in number theory"
  homepage "https://pari.math.u-bordeaux.fr/"
  url "https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.11.2.tar.gz"
  sha256 "4a6532b3c77350363fa618ead5cd794a172d7b7e5757a28f7788e658b5469339"

  bottle do
    sha256 "a88f042d922a2293a48da12db2d31c0e85042e9bf16ced84cd71eff17139275c" => :mojave
    sha256 "5d81ced4deafdd19a9bed498f7a4258865b44bb155d347c038c3dc15c3ed8bd9" => :high_sierra
    sha256 "342bc9f70a5203b9c73657353b30b2873f3b4c369aeeb1cfb258b33bfec4cf4c" => :sierra
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
  end

  def caveats; <<~EOS
    If you need the graphical plotting functions you need to install X11 with:
      brew cask install xquartz
  EOS
  end

  test do
    (testpath/"math.tex").write "$k_{n+1} = n^2 + k_n^2 - k_{n-1}$"
    system bin/"tex2mail", testpath/"math.tex"
  end
end
