class Btparse < Formula
  desc "BibTeX utility libraries"
  homepage "https://metacpan.org/pod/distribution/Text-BibTeX/btparse/doc/btparse.pod"
  url "https://cpan.metacpan.org/authors/id/A/AM/AMBS/btparse/btparse-0.35.tar.gz"
  sha256 "631bf1b79dfd4c83377b416a12c349fe88ee37448dc82e41424b2f364a99477b"

  bottle do
    cellar :any
    sha256 "d69b814282b1205eb311f2b8f1f2d0077e2adeef72c2a010084eec34ffef7b71" => :mojave
    sha256 "92fe826bfbaed8583343dbae8d2cf51d6161658e8ecd44a4bf7a308ab1f06d61" => :high_sierra
    sha256 "b31041f88e5253fd880d38190b4828f8c9cee34f141352d5c3b70b33e18d824f" => :sierra
  end

  def install
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
