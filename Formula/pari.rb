class Pari < Formula
  desc "Computer algebra system designed for fast computations in number theory"
  homepage "https://pari.math.u-bordeaux.fr/"
  url "https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.13.2.tar.gz"
  sha256 "1679985094a0b723d14f49aa891dbe5ec967aa4040050a2c50bd764ddb3eba24"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://pari.math.u-bordeaux.fr/pub/pari/unix/"
    regex(/href=.*?pari[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "ded4bc8651cbbab6d1c13f1209b3d013c39d712dee28ed38e2e927052d4acd77"
    sha256 big_sur:       "84b7739fcd41c82756c2610a6b6e7686d52d9b338b9cd23b9bc7405aea3b8901"
    sha256 catalina:      "6eafc6e4947af844a2984f78ee3769df27be397d2beeab046595c87cf54a0576"
    sha256 mojave:        "6f745e024e7cd4acbea3db05f8942c843549aa0003c621bb597ac9982a65e56d"
    sha256 x86_64_linux:  "3b62dbe1570c79d82b68c5093b621c4584eb0111f71f75c9aa9dfcb1ac1baef8"
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

    os = "mac"
    on_linux { os = "linux" }
    # Avoid references to Homebrew shims
    inreplace lib/"pari/pari.cfg", HOMEBREW_LIBRARY/"Homebrew/shims/#{os}/super/", "/usr/bin/"
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
