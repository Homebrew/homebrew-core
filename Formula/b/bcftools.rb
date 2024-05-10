class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/bcftools/releases/download/1.20/bcftools-1.20.tar.bz2"
  sha256 "312b8329de5130dd3a37678c712951e61e5771557c7129a70a327a300fda8620"
  # The bcftools source code is MIT/Expat-licensed, but when it is configured
  # with --enable-libgsl the resulting executable is GPL-licensed.
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "a378684c1b71b544c76cd3189ebafe358aad27aba97998b9954807bb65443e3f"
    sha256 arm64_ventura:  "ee2d762bd2f6841aa212f97e8789cb55b70da179f858d7525fa34002d20a6b77"
    sha256 arm64_monterey: "618464643a867483b584004a647a795cd3ab82f04d4099d7db7b897138c3295a"
    sha256 sonoma:         "947419ff302a6d111c15aea9a78ea654d8a70f5e0474cce2e9cb5edff4b342aa"
    sha256 ventura:        "4563f25f24c54910f12137f736691c3f06148847e8b283e3841810b33d7504e3"
    sha256 monterey:       "9ba8b88890f7d92add261950bca77e32638d4597e2a82191598944fd42efff39"
    sha256 x86_64_linux:   "b6a25d85a1a9db04e6636c213fb47428f3f2c0fbbf55e6b46b80fb822099a2a7"
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
