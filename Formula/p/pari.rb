class Pari < Formula
  desc "Computer algebra system designed for fast computations in number theory"
  homepage "https://pari.math.u-bordeaux.fr/"
  url "https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.19.1.tar.gz"
  sha256 "419553b11ff8c3ecb8e9031b7d91d7cee003a5d721e685fcb499565c96fe2943"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://pari.math.u-bordeaux.fr/pub/pari/unix/"
    regex(/href=.*?pari[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "a03865fe7af505f8c0160920f78f19aea5fde67dc582e748f3649668014b02c7"
    sha256 arm64_tahoe:       "623ae5e33125fae3d5ee61504964333961bbf00add579dec9cff08d9a009750b"
    sha256 arm64_sequoia:     "d9d1cd586b3499a1bc8750745487e90f3bbe1a4ce98d1fca0dc156e2c891c438"
    sha256 arm64_linux:       "907cd39b53b8e598587893c20ed97da3cdea9f2026102e2223ea7c87bf3d4f99"
    sha256 x86_64_linux:      "ed1a87e02b58bfd4329dc6c35238f5281ff460a3a4dda85049c1e3599ea14ee9"
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
