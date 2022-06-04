class Btparse < Formula
  desc "BibTeX utility libraries"
  homepage "https://metacpan.org/pod/distribution/Text-BibTeX/btparse/doc/btparse.pod"
  url "https://cpan.metacpan.org/authors/id/A/AM/AMBS/btparse/btparse-0.35.tar.gz"
  sha256 "631bf1b79dfd4c83377b416a12c349fe88ee37448dc82e41424b2f364a99477b"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "d69e49048e5366097bd7fe06b5ab9e40e3e97602896c613706559ab2c7aa4295"
    sha256 cellar: :any,                 big_sur:       "6080f2a4c252d49a4b265807ce77c290bd881b5339b7b2c19c5efc8a7f40b871"
    sha256 cellar: :any,                 catalina:      "6ce6b4e17c2559540007f3e15e38ee5f4eff1cc5dd6782e87089abf824a94e90"
    sha256 cellar: :any,                 mojave:        "d69b814282b1205eb311f2b8f1f2d0077e2adeef72c2a010084eec34ffef7b71"
    sha256 cellar: :any,                 high_sierra:   "92fe826bfbaed8583343dbae8d2cf51d6161658e8ecd44a4bf7a308ab1f06d61"
    sha256 cellar: :any,                 sierra:        "b31041f88e5253fd880d38190b4828f8c9cee34f141352d5c3b70b33e18d824f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb28ef3caa60d179c008ab9fbd54395014c35119cb9b1c1f2168a3e6bde294d0"
  end

  def install
    # Fix flat namespace usage
    inreplace "configure", "${wl}-flat_namespace ${wl}-undefined ${wl}suppress", "${wl}-undefined ${wl}dynamic_lookup"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.bib").write <<~EOS
      @article{mxcl09,
        title={{H}omebrew},
        author={{H}owell, {M}ax},
        journal={GitHub},
        volume={1},
        page={42},
        year={2009}
      }
    EOS

    system "#{bin}/bibparse", "-check", "test.bib"
  end
end
