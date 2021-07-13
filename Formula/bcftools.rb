class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/bcftools/releases/download/1.13/bcftools-1.13.tar.bz2"
  sha256 "13bfa1da2a5edda8fa51196a47a0b4afb3fef17516451e4f0e78477f3dd30b90"
  # The bcftools source code is MIT/Expat-licensed, but when it is configured
  # with --enable-libgsl the resulting executable is GPL-licensed.
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_big_sur: "7ecca21cb2e9c1e7f434277ecac4647d6fd09ebdbd37e9ca7c79c87be7a46d6d"
    sha256                               big_sur:       "7d8b089cceb6dd839ccebf5a041bd02fd5486d4e991116dc9f6a67c8ee0be4f0"
    sha256                               catalina:      "901bc523b121579bc3ddbe02fc1723fd16c508bf517c13ae8f7c71b5285c361c"
    sha256                               mojave:        "56b743ff1dd22627296a5e015935e8d98793360e8eec5525e6efc0eb30a3da94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70efff11e6624186c0231d0a291b57a45a674495f0e00ad83e3d5da0d35d5a0a"
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
