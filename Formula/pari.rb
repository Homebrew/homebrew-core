class Pari < Formula
  desc "Computer algebra system designed for fast computations in number theory"
  homepage "https://pari.math.u-bordeaux.fr/"
  url "https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.15.2.tar.gz"
  sha256 "b04628111ee22876519a4b1cdafb32febaa34eafa24f9e81f58f8d057fbee0dd"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://pari.math.u-bordeaux.fr/pub/pari/unix/"
    regex(/href=.*?pari[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d9ff317d18a988e4a7a52a878513dcf5fdd855447f8e679cea075114f786403f"
    sha256 cellar: :any,                 arm64_monterey: "02efa3d5d389107c572f6d089c0624ddf0543e6f919081b334cc165f3140584e"
    sha256 cellar: :any,                 arm64_big_sur:  "fa7a0c520f8b2ead0c3de0a56fe22e3a98fffb67e2ee0764049d222aa11f4747"
    sha256 cellar: :any,                 ventura:        "8979374f8ef9476c3e65fe00bdfcad02c888671ed727a86a8150cc2369db8894"
    sha256 cellar: :any,                 monterey:       "e35f684ff0ad226a97470cee0fe6b85b829c7404ee34d5079306b63827745c4c"
    sha256 cellar: :any,                 big_sur:        "758617cd740dddeafbdb63febd37b87a5f5b08026f1802905ad6647bf172af53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a64c300b846f1a101459b349312a7a13bbf15705d5641d42341f500454f0b162"
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
