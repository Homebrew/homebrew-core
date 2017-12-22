class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "http://www.htslib.org/"
  url "https://github.com/samtools/bcftools/releases/download/1.6/bcftools-1.6.tar.bz2"
  sha256 "293010736b076cf684d2873928924fcc3d2c231a091084c2ac23a8045c7df982"

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
