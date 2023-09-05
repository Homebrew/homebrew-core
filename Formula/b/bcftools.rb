class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/bcftools/releases/download/1.18/bcftools-1.18.tar.bz2"
  sha256 "d9b9d36293e4cc62ab7473aa2539389d4e1de79b1a927d483f6e91f3c3ceac7e"
  # The bcftools source code is MIT/Expat-licensed, but when it is configured
  # with --enable-libgsl the resulting executable is GPL-licensed.
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "0f945c230807755c568393c051065f7c6eaf3952bca6489d7e62aa397c7f327e"
    sha256 arm64_monterey: "6ee5ad3e81b57c519137d98d59737922df24be172ebf60839f36e704808453a7"
    sha256 arm64_big_sur:  "fa7df4a6c18a3006a630c25358e14460ad86bbbf255b5cd1092da80a8e17f699"
    sha256 ventura:        "82f354a9993b8c0aba2ec76e127a0a79f6c49f5f8f810c8f25ca75e8f7ac7534"
    sha256 monterey:       "59aca634bbe02041204c4d96f40b0ef71cfe5bd060163d06ad8f8809e01aa1a3"
    sha256 big_sur:        "04592c369a7b5a83847340f09895ee1530c7d2f47cbcc9382fbafe74c7157c81"
    sha256 x86_64_linux:   "37e5c41967d7eea82cfa03d1aec3b696878736ee98296d0492ed35a966fd9e7a"
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
