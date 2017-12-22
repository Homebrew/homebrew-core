class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "http://www.htslib.org/"
  url "https://github.com/samtools/bcftools/releases/download/1.6/bcftools-1.6.tar.bz2"
  sha256 "293010736b076cf684d2873928924fcc3d2c231a091084c2ac23a8045c7df982"

  bottle do
    sha256 "d4371f90c99fec2a9e55a3d8b138a511209105a8e32cac39ffb25bdc0e487b10" => :high_sierra
    sha256 "d451c2fa5530db082ac1a6e015fb9895a51bccf2a89fd381afc781a7d3c2d8a1" => :sierra
    sha256 "fe3bf73cbb6412fef8270a4aae84cf5309d6221909d8f274ffe46a0e1c98d514" => :el_capitan
  end

  depends_on "gsl"
  depends_on "htslib"
  depends_on "xz"

  def install
    # Remove for > 1.6
    # Reported 2 Oct 2017 https://github.com/samtools/bcftools/issues/684
    inreplace "Makefile",
      "PLUGIN_FLAGS = -bundle -bundle_loader bcftools",
      "PLUGIN_FLAGS = -bundle -bundle_loader bcftools -Wl,-undefined,dynamic_lookup"

    system "./configure", "--prefix=#{prefix}",
                          "--with-htslib=#{Formula["htslib"].opt_prefix}",
                          "--enable-libgsl"

    # Fix install: cannot stat ‘bcftools’: No such file or directory
    # Reported 21 Dec 2017 https://github.com/samtools/bcftools/issues/727
    system "make"

    system "make", "install"

    pkgshare.install "test/query.vcf"
  end

  test do
    output = shell_output("#{bin}/bcftools stats #{pkgshare}/query.vcf")
    assert_match "number of SNPs:\t3", output
    assert_match "fixploidy", shell_output("#{bin}/bcftools plugin -l")
  end
end
