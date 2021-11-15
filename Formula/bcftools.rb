class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/bcftools/releases/download/1.14/bcftools-1.14.tar.bz2"
  sha256 "b7ef88ae89fcb55658c5bea2e8cb8e756b055e13860036d6be13756782aa19cb"
  # The bcftools source code is MIT/Expat-licensed, but when it is configured
  # with --enable-libgsl the resulting executable is GPL-licensed.
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_monterey: "744a97a27e3bad5c82d483d388fb49af8c13b67c3186da29c57da2fb5fda0c41"
    sha256                               arm64_big_sur:  "13bc31d2086972697f374bcf68a24deaa389a57ed2adb4a3d432fd72a60ffcda"
    sha256                               monterey:       "0f9241650659b12f4196cc1401714cee3688f6e72021c654c93f43eff066de1d"
    sha256                               big_sur:        "e4cd74edeaa7c41ae71263732822b732b8d1e7cde98ce813dcd1fc1d2bf0529e"
    sha256                               catalina:       "ddf5d0fe3d61c1386a383469a3bc7bb6bacc0ae11e6eaa3ef21ca3d38968e6a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8db6b53f0fe4b88ec4d1e41297a1487429b937e0579c0ba8ee2c67a5729216c3"
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
