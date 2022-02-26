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
    sha256                               arm64_monterey: "720e4440201c8f4d048337811dfc84da26b0454d9eb9151a77b5f32c4e346f60"
    sha256                               arm64_big_sur:  "fbafbf36e4be779d0882d97cbbc3bd1dec5d27c20b124b7be21bb1c6f01f5892"
    sha256                               monterey:       "59833175a820a810fc9c7b40fcbf94c4e6491e38351ac1fe4dc639e4a81ca5fb"
    sha256                               big_sur:        "42bd1f0da1b5d7a2a46e2d6f1de19b37c758bf4757965f32d6d83f8ad4e762b4"
    sha256                               catalina:       "edee39c4d848d735047cebe889dd25de093ace43f60483d5a782e0d38ab6e105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "def6f84ec99d8fe9990ff9df452730d239afe527b55a60fefbbe3ea245173c04"
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
