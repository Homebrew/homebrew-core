class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/bcftools/releases/download/1.24/bcftools-1.24.tar.bz2"
  sha256 "8caddc22610ee2851666047c859bb91da0c1e32d0c2ec553db6f153ad130e46f"
  # The bcftools source code is MIT/Expat-licensed, but when it is configured
  # with --enable-libgsl the resulting executable is GPL-licensed.
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "035649933e0498ead23e23830ab3e61fca26ad5b02e34b2a193c7408a2d02a7f"
    sha256 arm64_sequoia: "98c154058fd6daebe20ab3f4a019bb787b0a213af545fd2587aad748bc045652"
    sha256 arm64_sonoma:  "06ff2e83de9b5f213f51ac968e0b3b320e30df3249a0643497660d2164f242d1"
    sha256 sonoma:        "5974db1a9566465634107c76b784a926dd5146f1da1a53421b81e23b01e6fae0"
    sha256 arm64_linux:   "bd60092c9132fa643aa4d879f84d2ceb8c620d8f281c851b27291ba63fac229d"
    sha256 x86_64_linux:  "f8f00ca1785f9fead8fe43d74a46f57e1446b897c941ddc607b16c265ff105f2"
  end

  depends_on "gsl"
  depends_on "htslib"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-htslib=#{formula_opt_prefix("htslib")}",
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
