class Pari < Formula
  desc "Computer algebra system designed for fast computations in number theory"
  homepage "https://pari.math.u-bordeaux.fr/"
  url "https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.15.4.tar.gz"
  sha256 "c3545bfee0c6dfb40b77fb4bbabaf999d82e60069b9f6d28bcb6cf004c8c5c0f"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://pari.math.u-bordeaux.fr/pub/pari/unix/"
    regex(/href=.*?pari[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "81eeae7d7743b0bca112391ad15dca0f0e49f719186733898a07eb6371b1e5e3"
    sha256 cellar: :any,                 arm64_ventura:  "4fd34453e10ccd762b5eab6f468d14e3910d461dd9eee836fcedf015d284c48c"
    sha256 cellar: :any,                 arm64_monterey: "9b61606bf5a249e9c54b0c3d568b77908e407270c3873059508ce70e24a35d12"
    sha256 cellar: :any,                 arm64_big_sur:  "8af658d0d0757e405fec12c0e0865c61713db0399c84f3aa8f761251bf023b28"
    sha256 cellar: :any,                 sonoma:         "6b3def21f6b34575dbdac1b81ca39f53be693cc31e272e36bdffbb4206dff9b3"
    sha256 cellar: :any,                 ventura:        "39161134fcc9cd9b8bf6f8ecdf553aa71249504cba6dd3a52a6e0293322d35d2"
    sha256 cellar: :any,                 monterey:       "5d45124e3605bc48ccd19bd1fcb388201f65b1e6681022c54f564b05ebbe2a98"
    sha256 cellar: :any,                 big_sur:        "3d56fce67a234dc3aa1aee35b2759aeb865c29986d51434b218968d2d348def6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf41b599a3427be175d4d91f16a39cee935b0ad4e743943160d3b4a78cef6b16"
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
