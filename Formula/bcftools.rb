class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "http://www.htslib.org/"
  url "https://github.com/samtools/bcftools/releases/download/1.7/bcftools-1.7.tar.bz2"
  sha256 "dd4f63d91b0dffb0f0ce88ac75c2387251930c8063f7799611265083f8d302d1"

  bottle do
    sha256 "55eb87755553c4679a31801e822b5975607196ef34021796e46f5f32a7bc397a" => :high_sierra
    sha256 "e395ccbbaa803a095d59437f76167e6b6d61053d3ee562ee848dc305d7b4bbee" => :sierra
    sha256 "bcfd075273b9918e5632e45b20f5ac5b1788540c02d41877bcc17f2041e687aa" => :el_capitan
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
