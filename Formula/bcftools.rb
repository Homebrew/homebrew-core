class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/bcftools/releases/download/1.11/bcftools-1.11.tar.bz2"
  sha256 "3ceee47456ec481f34fa6c34beb6fe892b5b365933191132721fdf126e45a064"
  license "MIT"

  livecheck do
    url "https://github.com/samtools/bcftools/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 "fb3b25ef0fa059b400d4094e9719208c74b7665c45d378aec46f26efe5c179c6" => :catalina
    sha256 "cbc6f8a457ddb9d4e6c14a1b5f78023f66305aa9df7f8495252b9a774821fec9" => :mojave
    sha256 "d6ea207bfe680f637147e39e7cf2f3311709dc3c1964bdf5d3506d13200da7a8" => :high_sierra
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
