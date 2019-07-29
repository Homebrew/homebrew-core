class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/bcftools/releases/download/1.9/bcftools-1.9.tar.bz2"
  sha256 "6f36d0e6f16ec4acf88649fb1565d443acf0ba40f25a9afd87f14d14d13070c8"

  bottle do
    sha256 "778fdf169be86376f40ad9c14d2def00f49a486861f9b1f80b6034de0be5bc92" => :mojave
    sha256 "4f7b1e8f7df9838484fc0f312d384008a7fc13a7efab375010a9f9d1a1abcec4" => :high_sierra
    sha256 "6bff92a6b2c5aa70f43b6cdb83ee75ab795e41675c289e6a5ffb0428b9192edc" => :sierra
    sha256 "17689cca5a46127c5b90cef24f40cd2446be3803ab0ba315469c254bad50fd74" => :el_capitan
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
