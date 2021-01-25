class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.11/htslib-1.11.tar.bz2"
  sha256 "cffadd9baa6fce27b8fe0b01a462b489f06a5433dfe92121f667f40f632538d7"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "041b57665a510b5f997378bf3e3ce77c514dd3d926bb657b8ed51c5d3d12428d" => :big_sur
    sha256 "064702cff6bf08fcde27f3315ee3f252d4ab402cec419165bc9c3a29b0ff88f1" => :arm64_big_sur
    sha256 "f28d03e151afa13f70ed32382fe39dfbd519b94684bffc1351e38c928156f678" => :catalina
    sha256 "e32ece4437430fb982ab295b6efaa9bed569dd5a661adcf1bc4240b48ae72914" => :mojave
    sha256 "b0fd73dc104edc3fc591a998ce27fe99e8086873b0ac29775532374213225a1f" => :high_sierra
  end

  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-libcurl"
    system "make", "install"
    pkgshare.install "test"
  end

  test do
    sam = pkgshare/"test/ce#1.sam"
    assert_match "SAM", shell_output("#{bin}/htsfile #{sam}")
    system "#{bin}/bgzip -c #{sam} > sam.gz"
    assert_predicate testpath/"sam.gz", :exist?
    system "#{bin}/tabix", "-p", "sam", "sam.gz"
    assert_predicate testpath/"sam.gz.tbi", :exist?
  end
end
