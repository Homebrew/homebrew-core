class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/bcftools/releases/download/1.21/bcftools-1.21.tar.bz2"
  sha256 "528a4cc1d3555368db75a700b22a3c95da893fd1827f6d304716dfd45ea4e282"
  # The bcftools source code is MIT/Expat-licensed, but when it is configured
  # with --enable-libgsl the resulting executable is GPL-licensed.
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia:  "24923a0c1f5695cebd051f338ae43f532183f086afb5be6284a2a28b26aa3296"
    sha256 arm64_sonoma:   "c3f336afc9026b9b782a955e4105d208bab0ec6f8f1701171d3093bff70487e0"
    sha256 arm64_ventura:  "f380f5a44355aa36e14234551ef6cadd5c8cae4889af33acaa12f3759309e04b"
    sha256 arm64_monterey: "a59a1531f579d313e6d4650a47e75d93b5a978758a67b0dd417aabd507994e00"
    sha256 sonoma:         "ed2ea3659a829947e39e6a9fc8c295f483052a7e54f7b369682a1dc4574d52cf"
    sha256 ventura:        "a0dea566d19deacb5b1d6886c2f7b21a49a01cfb554efbe2d4462e1a0edbfc81"
    sha256 monterey:       "49ed253ef4ddfeaa96b1a96c4b51c60992cf1248f087ab8bd534c82facdb6a44"
    sha256 x86_64_linux:   "d0b13624d5d87f0b28715e7ce74b3c78daf2f6a3db7f025a6b9fd434f0aff2f8"
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
