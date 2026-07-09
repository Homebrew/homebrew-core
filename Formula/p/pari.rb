class Pari < Formula
  desc "Computer algebra system designed for fast computations in number theory"
  homepage "https://pari.math.u-bordeaux.fr/"
  url "https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.17.4.tar.gz"
  sha256 "02651d99c391007d384b3fadbc20abc6916b77036f9e496c99e9ce8688ca4b53"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://pari.math.u-bordeaux.fr/pub/pari/unix/"
    regex(/href=.*?pari[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "4a86a32a47d544444b4d6bd72bbc39e9231c748d0be5b85883f49fb6985bb65c"
    sha256 arm64_sequoia: "a4d89db11849cd0dc9949330b4216955516ea3d3fe4b3688d78019923fa0e71b"
    sha256 arm64_sonoma:  "e101dd4185f5d3b5951c2993ecc412f8004a525b97850851e61e885a66b2b8e9"
    sha256 tahoe:         "393167d1ddd79f88f11ad0e60231d8755e724e713b72bffe09c1a21ad35647cf"
    sha256 sequoia:       "caecf47acfe7ed16dd0317a45d39eaf86796498c13655959f5601bbd80e2ff1b"
    sha256 sonoma:        "f5255fa7875d040651679e22907d00cd19e7967a82407f9f2f28aea77f308f92"
    sha256 arm64_linux:   "403a9888502eabf27e2af4d60faefdb9aa645643074e4be48620004ce503c328"
    sha256 x86_64_linux:  "3b0eac8b485db142627ed66b9b1517ddbda868651e11e2b3a1ed106f5e0bee1c"
  end

  depends_on "gmp"
  depends_on "readline"

  def install
    # Work around for optimization bug causing corrupted last_tmp_file
    # Ref: https://github.com/Homebrew/homebrew-core/issues/207722
    # Ref: https://pari.math.u-bordeaux.fr/cgi-bin/bugreport.cgi?bug=2608
    ENV.O1 if ENV.compiler == :clang

    readline = formula_opt_prefix("readline")
    gmp = formula_opt_prefix("gmp")
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
