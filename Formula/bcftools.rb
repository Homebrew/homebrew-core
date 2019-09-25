class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/bcftools/releases/download/1.9/bcftools-1.9.tar.bz2"
  sha256 "6f36d0e6f16ec4acf88649fb1565d443acf0ba40f25a9afd87f14d14d13070c8"
  revision 1

  bottle do
    sha256 "4305f9079357716f0aff1d93980c4f2e1e6a2b364fe393545284cf8b6701f3e7" => :mojave
    sha256 "46dc97038ccd6482801e6260a234f591115e7da598634a63442bacbd0c1f7700" => :high_sierra
    sha256 "f43e5a0e40dcec92d183b9014a1b06f3fb0452c81ee8c2b4ed159c84bafb5b62" => :sierra
  end

  depends_on "gsl"
  depends_on "htslib"
  depends_on "xz"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-htslib=#{Formula["htslib"].opt_prefix}",
                          "--enable-libgsl"
    system "make", "install"
    pkgshare.install "test/query.vcf"
  end

  test do
    output = shell_output("#{bin}/bcftools stats #{pkgshare}/query.vcf")
    assert_match "number of SNPs:\t3", output
    assert_match "fixploidy", shell_output("#{bin}/bcftools plugin -l")
  end
end
