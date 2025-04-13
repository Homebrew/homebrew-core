class Pari < Formula
  desc "Computer algebra system designed for fast computations in number theory"
  homepage "https://pari.math.u-bordeaux.fr/"
  url "https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.17.2.tar.gz"
  sha256 "7d30578f5cf97b137a281f4548d131aafc0cde86bcfd10cc1e1bd72a81e65061"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://pari.math.u-bordeaux.fr/pub/pari/unix/"
    regex(/href=.*?pari[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256               arm64_sequoia: "5dd598ddd07c409257bad75db3c20f0da0509c07b3be0e0a4248535457594a51"
    sha256               arm64_sonoma:  "bf58c1bdf22c69cf679423fa396efc69996edb7567bd30811e65fccb20816558"
    sha256               arm64_ventura: "0739c7e681b5776a48634fea706d860b950f28b3020ae9f7ce830121f6208e7f"
    sha256 cellar: :any, sonoma:        "ddddbc46872cd877dc6d2bb383ec2c796a726c84b952a0a648220d98cfb00165"
    sha256 cellar: :any, ventura:       "325077871981fd84776c2cb9119b402bf5fd4ba865615e99cfeb8814b10eec08"
    sha256               arm64_linux:   "2bb804bf036de998864490817c533f1b5f1da685365c28a1bd66c4d92a17eb7a"
    sha256               x86_64_linux:  "045451f669359b20630a47b6b9fb2da2d2ad7ee2442965ddefb8efc7e67f776d"
  end

  depends_on "gmp"
  depends_on "readline"

  def install
    # Work around for optimization bug causing corrupted last_tmp_file
    # Ref: https://github.com/Homebrew/homebrew-core/issues/207722
    # Ref: https://pari.math.u-bordeaux.fr/cgi-bin/bugreport.cgi?bug=2608
    ENV.O1 if ENV.compiler == :clang

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

    (testpath/"test.gp").write <<~GP
      default(parisize,"1G");
      default(realprecision,10);
      dist(a,b) = sqrt(a^2+b^2);
      print(dist(1,2));
    GP
    assert_equal "2.236067977\n", pipe_output("#{bin}/gp --quiet test.gp", "", 0)
  end
end
