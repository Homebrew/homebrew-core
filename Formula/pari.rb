class Pari < Formula
  desc "Computer algebra system designed for fast computations in number theory"
  homepage "https://pari.math.u-bordeaux.fr/"
  url "https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.13.3.tar.gz"
  sha256 "ccba7f1606c6854f1443637bb57ad0958d41c7f4753f8ae8459f1d64c267a1ca"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://pari.math.u-bordeaux.fr/pub/pari/unix/"
    regex(/href=.*?pari[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4953a24a3d70dd39a57c987aef382c0e150bb185ce35c25c4410cb8685a8e059"
    sha256 cellar: :any,                 arm64_big_sur:  "96c77a5772be062e5f819af0526ad34c9060de50d8017b2ca0946e883f6e0c56"
    sha256 cellar: :any,                 monterey:       "ebee4731dc1f7a83c27e7d15af51bcf130330f5ebc59726cf632a29f65b7fff6"
    sha256 cellar: :any,                 big_sur:        "1425bcb4a39b7ce00dcd17ff0adf6180f51efe71b320bb2e8c0d082a45945cb3"
    sha256 cellar: :any,                 catalina:       "c107ebaa7fbadf071954735b41ca3f56764db05b80da3d7bef4277a3fb517fc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b505207b83024ef3997c9ed4fe380a5d2e0c98b2b97db619821d82403fb8b91"
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
