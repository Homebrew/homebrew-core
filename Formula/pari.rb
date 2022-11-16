class Pari < Formula
  desc "Computer algebra system designed for fast computations in number theory"
  homepage "https://pari.math.u-bordeaux.fr/"
  url "https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.15.1.tar.gz"
  sha256 "45419db77c6685bee67e42e0ecb78e19ef562be7aafc637c8a41970f2e909e3d"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://pari.math.u-bordeaux.fr/pub/pari/unix/"
    regex(/href=.*?pari[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b8c6c24afa6d76c7025cdd8cfafdf524cd78489921d4845ae7709195e2023a5e"
    sha256 cellar: :any,                 arm64_monterey: "5e1f8779031bf1f1f726bdaf390e177911e74a6e481774d610256c5754e905ee"
    sha256 cellar: :any,                 arm64_big_sur:  "2602a7dbf4a9a41518c33a92f954fc54728ded80e50b5f13b4c2214763585c34"
    sha256 cellar: :any,                 ventura:        "adf7be1cbf641c5ca51806a0e4ef5614384224967e74bc1a1a3a42134cbc26f3"
    sha256 cellar: :any,                 monterey:       "8c697b116201a79137a0cb87162ad61e6aecff76f5343764b9cc159137cdb4ef"
    sha256 cellar: :any,                 big_sur:        "6606f288f791cc3deac3a2f8fbc819fc34403e2aa05d9d939050d76f73884d8b"
    sha256 cellar: :any,                 catalina:       "11b5ad9141c7d2e6b0a8e80a6036736cc09df023037f1efaff4ce51b1a1d7d5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44a7116eb391e9f523d2c3e22261bf3d23bc0a61760f16ccd54b7ed0326d84ea"
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
