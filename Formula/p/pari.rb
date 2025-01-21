class Pari < Formula
  desc "Computer algebra system designed for fast computations in number theory"
  homepage "https://pari.math.u-bordeaux.fr/"
  url "https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.17.1.tar.gz"
  sha256 "67ba6f3071233725258541e4f174b5efbc64c65ae5115bade9edfc45f1fde5dc"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://pari.math.u-bordeaux.fr/pub/pari/unix/"
    regex(/href=.*?pari[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6e3bac204e73cba93b99b3d205087289920a4ae794ff6b31fa2ba3d2cc241570"
    sha256 cellar: :any,                 arm64_sonoma:  "c016de97580e7f01abb72116b86614dd19dbe5bdbf50e98fe068f256154f706d"
    sha256 cellar: :any,                 arm64_ventura: "c97015a09844c87b71755498682442dae77a57650b33d59adeb8d64611dc9574"
    sha256 cellar: :any,                 sonoma:        "5c662e25dedb14ac7d151269de9ff0f08af2c0b022e850ad41db0b67b2964d6e"
    sha256 cellar: :any,                 ventura:       "306066cceb3bdb2ed7fb5d36d2e0fcd0f3c3543e6ae65e62405c223884eabbe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d59d53d361ef5babd2582a39ea6a909832fd0b794db1132ca820fed4c0a0394f"
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
