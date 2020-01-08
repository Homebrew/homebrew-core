class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/bcftools/releases/download/1.10/bcftools-1.10.tar.bz2"
  sha256 "2a37721b944772633f334cc0897c43430d56cf59d7363b72d5cd2cfc9ae3af83"

  bottle do
    sha256 "1937e40aa679e318739a7539c005b5b4cf4b464b70580804c473bfd4f60e1343" => :catalina
    sha256 "fd0fc2e7301bfdbe6c6bc8f1d89f3c70dcae4785b7d74cc450c7d7d9758efdd6" => :mojave
    sha256 "77553a88c85fb00925a8bb4f9d4d00ce3f81bb5e7643a9029ab29fa7d8f6dc4e" => :high_sierra
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
