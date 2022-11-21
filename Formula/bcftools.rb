class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/bcftools/releases/download/1.16/bcftools-1.16.tar.bz2"
  sha256 "90bf647c9ad79e10a243b8058c873de057fd7012e250d5ae6574839787a2ecd6"
  # The bcftools source code is MIT/Expat-licensed, but when it is configured
  # with --enable-libgsl the resulting executable is GPL-licensed.
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_ventura:  "225a59b2ce3035845071b9b620c3c981bfd9d8185fb18090047b156c1b7105da"
    sha256                               arm64_monterey: "65a2a78dd8fb87800fc5f46f020a73625cd1ac3a785a60140c473a96bd647ca0"
    sha256                               arm64_big_sur:  "b8bf1ee7fecde28d1facb2164ff6e398ed33c5ff1095129a2e323affbd0656d2"
    sha256                               ventura:        "0295cac1bd16a3438f5fc54f76600c81aa8bbc59a18a4c14f719797eee2d01bb"
    sha256                               monterey:       "82fb878c7e66acbe2e88da18ba11e6555b49d3c7ee857de606a1c7ea554472fe"
    sha256                               big_sur:        "50a2abedf76288f41c716d9e075712e20b6a1161e96ba0d77ed64f398f0d8df2"
    sha256                               catalina:       "4f59af51a89cbb746179dd7ce62f04e3d2c58ca1561cf6eeb00ed669d0550c36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2a6fd547af1d4e99e747d19c92c1c89a71a63544940581ce9281c0b28f9a5cb"
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
