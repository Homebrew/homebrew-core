class Pari < Formula
  desc "Computer algebra system designed for fast computations in number theory"
  homepage "https://pari.math.u-bordeaux.fr/"
  url "https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.13.4.tar.gz"
  sha256 "bcde9eceae1592814381c1697cdb7063567b6504201b1be47bb58920f3bce185"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://pari.math.u-bordeaux.fr/pub/pari/unix/"
    regex(/href=.*?pari[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e1c950eecbb7fe0877e054706dd3ea302fd35197aeb1268d15adf7ff7a006a23"
    sha256 cellar: :any,                 arm64_big_sur:  "ff5c62049416d85cb3981f2913b45901a5738b7bf4c23de678f0e4749d4354a7"
    sha256 cellar: :any,                 monterey:       "8613b0be1eb6140ae00e70b1da63891302e828a9d7fbb335e02d8c417c0fcaca"
    sha256 cellar: :any,                 big_sur:        "c039a203f00b495a0d0d0c304383fd26ee4dc0b23d0133c1f6dcc928285aec11"
    sha256 cellar: :any,                 catalina:       "b6067a936ab86bc50e247b0fdd75704f73f373679b55463d6bc5e8b549a7e407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5482cc0f5056c067a3b5b85fdf4346416d3f40c2449362b52d4ae848f292888c"
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
