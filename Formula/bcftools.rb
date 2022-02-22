class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/bcftools/releases/download/1.15/bcftools-1.15.tar.bz2"
  sha256 "1885ccb450a86e97a00aa905d7381ca9e07bd8967c05705a61d0007d2e22296e"
  # The bcftools source code is MIT/Expat-licensed, but when it is configured
  # with --enable-libgsl the resulting executable is GPL-licensed.
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_monterey: "f6dc63f7c76b06013acd6cc56917d92a36ead9ec1280f876dfbe93a724a1f143"
    sha256                               arm64_big_sur:  "57ac52202f614792d964d18f706ee0285e4f39f34f794d42686a861591b5d1c3"
    sha256                               monterey:       "02e025616ff6daf116c39cf5fbf62a0dab4c5cbcc460eac607e2a105ce30efd1"
    sha256                               big_sur:        "df5c39b00efc020cbf282dcf10f489d67c3dea591d7eb733131e3d08f7a14c06"
    sha256                               catalina:       "927aab202ad520ba0c44847404b6e1f2e6f1442dee49d08235125b767643ba07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57c32fb494027d88d9efabd8cfe15b158e32f0eb6e720ea6a228e04a8af53eaa"
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
