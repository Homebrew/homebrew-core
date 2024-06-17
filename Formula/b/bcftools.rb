class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/bcftools/releases/download/1.20/bcftools-1.20.tar.bz2"
  sha256 "312b8329de5130dd3a37678c712951e61e5771557c7129a70a327a300fda8620"
  # The bcftools source code is MIT/Expat-licensed, but when it is configured
  # with --enable-libgsl the resulting executable is GPL-licensed.
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "1038b3798c23fdb1ce42fffec5d1b5e5d537e2c582bc3435d5d245159722a321"
    sha256 arm64_ventura:  "932fe799ef1844cf163017eeb5fe520f8baf88abacab3dd3c8ab4dab7f057a15"
    sha256 arm64_monterey: "aaed2a4733eb0c84cbbd0e2fe9921e482902a11d21376a802466aa123f861246"
    sha256 sonoma:         "8c9fb7dd70a93ac7fe79adfbff71dca3c9dd67ef61cdb026736048125e2a2ac8"
    sha256 ventura:        "653db855d35c7c5d28978b30f152f28896e756201a1685d713f69fe9b97b14c3"
    sha256 monterey:       "0c820ad7cb45d41a06787d5a6b854499deb9d559f71ed85156cc62bdad3ff864"
    sha256 x86_64_linux:   "e1dcb52a4ada2458f2672845fda6911819cef369c4ce7899ad5ea660a5543a59"
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
