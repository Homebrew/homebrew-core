class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/bcftools/releases/download/1.17/bcftools-1.17.tar.bz2"
  sha256 "01f75d8e701d85b2c759172412009cc04f29b61616ace2fa75116123de4596cc"
  # The bcftools source code is MIT/Expat-licensed, but when it is configured
  # with --enable-libgsl the resulting executable is GPL-licensed.
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "cc923b5aeb11a0fcae0f8d705ed9038f5194a222e72ec031912d90e628278e36"
    sha256 arm64_monterey: "63e1db9175c816b9c07bb4af3fba7b99bf3d59de2f9bd0b6464f2f77b2d1c00e"
    sha256 arm64_big_sur:  "dc2f2cd5acefc3a0d5f211acf8cad4b207b6eb68c4fdfaa1d2fa24038723c22b"
    sha256 ventura:        "9d2b813a09bd6b7c172955304cb16babe0780600804cd541d42e7f7f357e779c"
    sha256 monterey:       "446b45c18e3ecc11fcf32549b45ff8dea489c3661acf3d9dc1b6292a379df778"
    sha256 big_sur:        "b899bd7074739743cf7862b21606317d96454bf7ab953d2134cf8c5ab6c5c257"
    sha256 x86_64_linux:   "490576693018307a1deb31182c8f532bd4e1ec749d7c86ca19d99e12c3f68e0d"
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
