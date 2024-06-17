class Pari < Formula
  desc "Computer algebra system designed for fast computations in number theory"
  homepage "https://pari.math.u-bordeaux.fr/"
  url "https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.15.5.tar.gz"
  sha256 "0efdda7515d9d954f63324c34b34c560e60f73a81c3924a71260a2cc91d5f981"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://pari.math.u-bordeaux.fr/pub/pari/unix/"
    regex(/href=.*?pari[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a537929fccb4f007daa839f9aea76de73c0326dfccc48d51e55aad38d506039f"
    sha256 cellar: :any,                 arm64_ventura:  "b03d85a4d0dbfa7131b2e61d8af7979ae4c41588efba24a14f84eb7c1498d64f"
    sha256 cellar: :any,                 arm64_monterey: "5051f201b86cde5edf7185bc99c10201cc927e2008a5d0d7340789cc120f33cd"
    sha256 cellar: :any,                 sonoma:         "c8b619544248cccf0887ccc339841b10eef08bb5f4a6490ec94453b3da51fab6"
    sha256 cellar: :any,                 ventura:        "72aa09993c08e33796d3908571d98176c1f43d64392038f2b1830e458df538dd"
    sha256 cellar: :any,                 monterey:       "4543f37e0d6ce1895a9e2acf50c5f1ebfcb65eb11f6eec15dfbb8fab1e6192c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83264d1d038b9ee66c1a056f80a9c40ca6e4bab9619d45b46e4d9c4995da5926"
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
