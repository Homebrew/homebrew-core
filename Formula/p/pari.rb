class Pari < Formula
  desc "Computer algebra system designed for fast computations in number theory"
  homepage "https://pari.math.u-bordeaux.fr/"
  url "https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.17.3.tar.gz"
  sha256 "8d9c4fcd584c468d27e0f23c36836587284452094c4b1c404c20c4b810462dcb"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://pari.math.u-bordeaux.fr/pub/pari/unix/"
    regex(/href=.*?pari[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "687e5d1d2fa3ef5d2833933b52b3137c4894bdb3d56a1b4e04dcd045b271abc3"
    sha256 arm64_sequoia: "8ced75493e3475237d74a086aa8816ca1801ed5d500894525c7d98cd18e8cd23"
    sha256 arm64_sonoma:  "3d21c691097747448ab40e08dfa67f8fd36f5a182f15f0bce7e29fa3dc0433ed"
    sha256 tahoe:         "edecfbb507dc4abb0779a15e664d3ab0a292e88bd847f49c18dd41133d17f951"
    sha256 sequoia:       "a6491dc92759d74111fb8b25a20a01178c821f5dd3b336a670e04844810f97dd"
    sha256 sonoma:        "0e06fd81183ff0471eb14c5d92acd38ec890b26237a913c9b1636d860d15651a"
    sha256 arm64_linux:   "1be7e33bcdf15fdddc9e4344ecc2fa87526aa2028b99ff15a9383de2056af163"
    sha256 x86_64_linux:  "91b8c8184e5bc18e90a54da5f87bc5ba678a40b7cbb6338a14558162f0bb5f31"
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
