class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.11/htslib-1.11.tar.bz2"
  sha256 "cffadd9baa6fce27b8fe0b01a462b489f06a5433dfe92121f667f40f632538d7"
  license "MIT"

  livecheck do
    url "https://github.com/samtools/htslib/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "15811a81a76e9245f555614843c079350f2e11ab7a043dde180a4b21e19f76a1" => :catalina
    sha256 "9ffe5808464115e1047a9d352d640eb127335e060314413538588bbfe287db69" => :mojave
    sha256 "03a7a1b503004ee5cb8df02df54ed0c9030dd57e27a14ccd3a0c6e713fc7e6b2" => :high_sierra
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
