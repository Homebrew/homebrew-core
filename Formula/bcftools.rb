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
    sha256                               arm64_big_sur: "b47f06c4f6387604539b13f7585c3bdc19fb2608aea3d566f4e2d7f5de5a7e3a"
    sha256                               big_sur:       "102cc97a217c3ddb65c4fb6ac8471d900288e7dc84659e2f926cca4ff0411cad"
    sha256                               catalina:      "276a5614f196d3a7784b1e2457de527044a05641b4db1166aead51c8b924e6b3"
    sha256                               mojave:        "59084bd2c8618ed243a3cd3800a9c65303ddcfd35fabaa226eb018d3ee8f7584"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8b1f45c4fb09670fd9c89e476e7154840b6d29786748755cbc4c050116c1f6b"
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
