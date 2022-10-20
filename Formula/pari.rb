class Pari < Formula
  desc "Computer algebra system designed for fast computations in number theory"
  homepage "https://pari.math.u-bordeaux.fr/"
  url "https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.15.0.tar.gz"
  sha256 "e474851e0d16d4e4f9a0d9612c746a2ae7c9a1ec185d04c440b1c74a85755685"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://pari.math.u-bordeaux.fr/pub/pari/unix/"
    regex(/href=.*?pari[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f5baec455e7bbd0b419f0a5abb6ca7267664b92b3723e57554ab2a6e213d1b7a"
    sha256 cellar: :any,                 arm64_big_sur:  "d3e141fecd1dcb4906aaa38e89db8735017985cbe4d3058d53577478bfdeab34"
    sha256 cellar: :any,                 monterey:       "1ded4350ef30875fe62b0e6530e74130b8a33f669fb1e620c2cb5053af49d8b6"
    sha256 cellar: :any,                 big_sur:        "3da7ec5a01c82c0ce8659d7f9c1a0e193332251b86754852d8e869ba291fe9cf"
    sha256 cellar: :any,                 catalina:       "c0401fba71a6596121722927c6325bb25c1ebeeb5a2a78313509101f904f846d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f785707533502dc8c9a10fd98441149bf5bcffb8953e18d7c11b95bf792946de"
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
