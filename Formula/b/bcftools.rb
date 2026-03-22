class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/bcftools/releases/download/1.23.1/bcftools-1.23.1.tar.bz2"
  sha256 "01899a46f9420cdc1385d52fcfc84cce2806f9c996b787081a90d7dfc85eafa3"
  # The bcftools source code is MIT/Expat-licensed, but when it is configured
  # with --enable-libgsl the resulting executable is GPL-licensed.
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "e18f1f51df328032926bc6b85f6302922fad2b6c05b463d753f11fc71280f054"
    sha256 arm64_sequoia: "47dfb967f316ffdee07ee14f562996279f74bb653082f6b7f903541f858d49ce"
    sha256 arm64_sonoma:  "72a210b390e78f56c9fad93f97d020450c1651972f29c12b8cfd00c57a0c6264"
    sha256 sonoma:        "5825e5b5a0a96012f4a397d24a283e5d6a00d4c141d608eae474f4ffc285ad59"
    sha256 arm64_linux:   "86d6c79f538b63489c16fe2db3da05008e1ec1add77cbbdbe111c006c6077b02"
    sha256 x86_64_linux:  "b18d88dc19989eeef092b7a49426d7d6d697d61e3b454725efa255183bc02478"
  end

  depends_on "gsl"
  depends_on "htslib"

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
