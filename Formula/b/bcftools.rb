class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/bcftools/releases/download/1.22/bcftools-1.22.tar.bz2"
  sha256 "f2ab9e2f605b1203a7e9cbfb0a3eb7689322297f8c34b45dc5237fe57d98489f"
  # The bcftools source code is MIT/Expat-licensed, but when it is configured
  # with --enable-libgsl the resulting executable is GPL-licensed.
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "6522598e958c511637e9d972977102f95a66b836577acf21e78d9c87ca76ce89"
    sha256 arm64_sequoia: "7bfda27c183789cb73ade0e4aeb4437a31edbee0bc0cfd16191ad3572f4d9f44"
    sha256 arm64_sonoma:  "b158694e48f72aa30dfa323d0ff8ef2745f57eab6d0e0092b5178e5506c834e9"
    sha256 arm64_ventura: "daf93a78cf3d50e8773288a2c0e0f7464e9a8ef8c81e3f9e1e5bd432c6aec16b"
    sha256 sonoma:        "a731d55be4c06169d30f2669fbffa00c8b4020a2d284e4c6f61aa5b765fdcd4d"
    sha256 ventura:       "d4df4f2814fb3f2d29454603ea88e37bd2c49b38f911c23e31a2961f3db76c78"
    sha256 arm64_linux:   "11f49299a8d6388e7cfc6d7e7e90b443fb60804c3c3a488aac024d5e72a74789"
    sha256 x86_64_linux:  "2879fc83d17d2474f2bdb37f44418953b75565cb4553501ba4da054fd373547e"
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
