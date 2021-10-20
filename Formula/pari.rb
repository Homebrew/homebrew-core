class Pari < Formula
  desc "Computer algebra system designed for fast computations in number theory"
  homepage "https://pari.math.u-bordeaux.fr/"
  url "https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.13.2.tar.gz"
  sha256 "1679985094a0b723d14f49aa891dbe5ec967aa4040050a2c50bd764ddb3eba24"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://pari.math.u-bordeaux.fr/pub/pari/unix/"
    regex(/href=.*?pari[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "ad45cc834d4454d84412e62628c85afbc2364748c1ddbbd9faeced13741e3ce7"
    sha256 cellar: :any,                 big_sur:       "a895d0124e8e155a943598c6e487da9c2695f4fe176bb6387ebd94b59db673ba"
    sha256 cellar: :any,                 catalina:      "c3345af4b6b315eb0ba121a96b0b475c9ce9ecf299529cba821e406d20deb666"
    sha256 cellar: :any,                 mojave:        "729e94c8cb530d7169c49569faa30c55a00cb799deffc3764b83c58386747879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92b1ef4819c3b0de0dd757f047949cf771ebf596e57aabed790824d14c61d8a0"
  end

  depends_on "gmp"
  depends_on "readline"

  def install
    readline = Formula["readline"].opt_prefix
    gmp = Formula["gmp"].opt_prefix
    system "./Configure", "--prefix=#{prefix}",
                          "--with-gmp=#{gmp}",
                          "--with-readline=#{readline}",
                          "--graphic=ps",
                          "--mt=pthread"

    # Explicitly set datadir to HOMEBREW_PREFIX/share/pari to allow for external packages to be found
    # We do this here rather than in configure because we still want the actual files to be installed to the Cellar
    objdir = Utils.safe_popen_read("./config/objdir").chomp
    inreplace %W[#{objdir}/pari.cfg #{objdir}/paricfg.h], pkgshare, "#{HOMEBREW_PREFIX}/share/pari"

    # make needs to be done in two steps
    system "make", "all"
    system "make", "install"

    # Avoid references to Homebrew shims
    inreplace lib/"pari/pari.cfg", Superenv.shims_path, "/usr/bin"
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
