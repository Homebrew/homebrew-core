class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/bcftools/releases/download/1.23/bcftools-1.23.tar.bz2"
  sha256 "5acde0ac38f7981da1b89d8851a1a425d1c275e1eb76581925c04ca4252c0778"
  # The bcftools source code is MIT/Expat-licensed, but when it is configured
  # with --enable-libgsl the resulting executable is GPL-licensed.
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "3168ab2f87336946ab3b30dba33b5ed48682fc4fff26ca98ccf8b97dad907f36"
    sha256 arm64_sequoia: "a156a1d191e9e74de34f6bb90e6ae37729405786435004956acd1af34f641339"
    sha256 arm64_sonoma:  "47bcb17fcbc9976b84f9d873a4c2a6cb2c15604263e7015c7e17e4ff11a39b48"
    sha256 sonoma:        "7b90b9ff1350cb4954144446555ae24abddc1b2e68c2f6f30fec815edb1a130c"
    sha256 arm64_linux:   "f0899a011add400aee632b0d1fd81dfc3a6f7b7a96527197e5b6af435a1d45d3"
    sha256 x86_64_linux:  "7d1a9f3a9232627f5ed94a1412467ff185677951bde18d7cd9d11b6f5076b642"
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
