class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/bcftools/releases/download/1.19/bcftools-1.19.tar.bz2"
  sha256 "782b5f1bc690415192231e82213b3493b047f45e630dc8ef6f154d6126ab3e68"
  # The bcftools source code is MIT/Expat-licensed, but when it is configured
  # with --enable-libgsl the resulting executable is GPL-licensed.
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "7d0cef3ea54c1cb29cc4c3e256f4f0724056df8becb24348e759a87c41efdf0a"
    sha256 arm64_ventura:  "4497d3d49861504111da7cff4f1acd5c1918990b1e7baf794e88231475b810f9"
    sha256 arm64_monterey: "83f9a5fba3390e5eb2316f1859a801abebfb732649e20d88636d2626669547d1"
    sha256 sonoma:         "d10c0820b18f864826bd78347c0cb4d93ab6abef2f8a2328652d8939c1210d1e"
    sha256 ventura:        "4405a4b4332022d0662f0cdac95d9d4c4495eba71c1f6bfc455fea3fab4f80ae"
    sha256 monterey:       "20a52eaa12b978c5c68337bbb93fe336dcdd82c102b96a1c3f6d57eb3a328f74"
    sha256 x86_64_linux:   "eb961804390c83ca2d83f59dcfd6e3174dff193e3d959a85cd11408aa053952b"
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
