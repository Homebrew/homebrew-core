class Pari < Formula
  desc "Computer algebra system designed for fast computations in number theory"
  homepage "https://pari.math.u-bordeaux.fr/"
  url "https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.11.2.tar.gz"
  sha256 "4a6532b3c77350363fa618ead5cd794a172d7b7e5757a28f7788e658b5469339"

  bottle do
    rebuild 1
    sha256 "ce1a71dc72b9b3dec85f30da62171caca919ffb253309d516e0b92bbc0533a6a" => :catalina
    sha256 "4e083fec22c646c2796cf0adb381b03d4e067b355a65bfccd7516ae891f3e57b" => :mojave
    sha256 "dba2c279f5f8ed677a7f248c7d575bf3462623390e50e4243fac9b118e7009a7" => :high_sierra
    sha256 "021f368e37e52f9dcb22fc665f8d5065532f8bd1a91bc8d9f817f6c4c8779970" => :sierra
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
