class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/bcftools/releases/download/1.15.1/bcftools-1.15.1.tar.bz2"
  sha256 "f21f9564873eb27ccf22d13b91a64acb8fbbfe4f9e4c37933a54b9a95857f2d7"
  # The bcftools source code is MIT/Expat-licensed, but when it is configured
  # with --enable-libgsl the resulting executable is GPL-licensed.
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_monterey: "547be287eadb9b767ab27232071c0fbd6895cea8de8470a657912d82ea90183c"
    sha256                               arm64_big_sur:  "856cc821f42aa3a34efc45c71fe5be9139605e52373d123bd04be511d1476380"
    sha256                               monterey:       "51b716a9f1b3b6889ee91f67135f0b3ef19bd4fbc298f1c3607497842684a5a2"
    sha256                               big_sur:        "da96ced1e7dea42220ef0bea1deecc4f38bb1f30d68cd980dbdb37cdd61a719c"
    sha256                               catalina:       "622b3e4e56e7b716824e3552e7cb9468753ba4dddacb7ef9b14e7e128cf68fc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7d57e0c0fbe7639362ba27ef336000e43e6be81c68d920cf7f86d6b4f50eeb5"
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
