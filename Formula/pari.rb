class Pari < Formula
  desc "Computer algebra system designed for fast computations in number theory"
  homepage "https://pari.math.u-bordeaux.fr/"
  url "https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.15.3.tar.gz"
  sha256 "adf5a58638cdafd72a8b48bc9f444972b23329c8d545a1d3ed1bbeb1b6569268"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://pari.math.u-bordeaux.fr/pub/pari/unix/"
    regex(/href=.*?pari[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0e26088334969cd77180daa8d782c44f30c3e98430c0d1e0a77669cad9817b7b"
    sha256 cellar: :any,                 arm64_monterey: "1a33becca15b5296c1115bf17a2e32b17a93e6a70621b0d7df8d49a8a10ea404"
    sha256 cellar: :any,                 arm64_big_sur:  "30dc8a1a74ff3d1c508a3ee079ce374e48daf7f6d5d24be85f72256c298ae075"
    sha256 cellar: :any,                 ventura:        "606d24e30ed76fb3a6fee6ec92a232c15c171635e0649d1bc414405855d69b62"
    sha256 cellar: :any,                 monterey:       "2c05804d5b5bddc0c9062da53cb7801f42ed8f7f7a3ec965628ac51d59a1b0d8"
    sha256 cellar: :any,                 big_sur:        "cb9197872fcb0f4978d9524ca6d6a33acdb7e3b1b446dcc8ce9c30422107c4e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb1993f3cae00b9947b0fddea78efed88dbdf79ff05803af754a4e2d31b2b0e2"
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
