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
    sha256 "6d232b149d6f1edc21116002d675d1f62ab0bf73158e67802ecb94091fa1ceaa" => :catalina
    sha256 "deb19fb24a4a943cf577b31b53f6aecf55e195fb62133e6b613d5e657e5dbbe0" => :mojave
    sha256 "af4d6172e2cdd40aaa8c49c6e4e8fde3cb90bf7f04f516bd1d1673e3e1659c73" => :high_sierra
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
