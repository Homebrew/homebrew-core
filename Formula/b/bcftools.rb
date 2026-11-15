class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/bcftools/releases/download/1.25/bcftools-1.25.tar.bz2"
  sha256 "f96e583d2315998645bb56756f1c8f230c489512db2655b0f623198ebc8a2d99"
  # The bcftools source code is MIT/Expat-licensed, but when it is configured
  # with --enable-libgsl the resulting executable is GPL-licensed.
  license "GPL-3.0-or-later"
  compatibility_version 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "2d5b76e3eb12c96e82f928673e1e9268086c4959b1a6b2705e77441084ec2932"
    sha256 arm64_tahoe:       "788fda609666ad0d17b1345da17fdbc1bae4543e5886e5795e5a4cf0ead42579"
    sha256 arm64_sequoia:     "1d18e3822d3fb8e0e5d9425989a54e0f747740564cdc3cc03b37d6d0175e91f5"
    sha256 arm64_linux:       "a0df12e410127716116332849f454886a0ca678949c4149c85d9a53d285ade9a"
    sha256 x86_64_linux:      "273e8611537036fac905d87805f12c4719fa7de1f090ce7bfe8b0f7a8d11bbe0"
  end

  depends_on "gsl"
  depends_on "htslib"

  deny_network_access!

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
