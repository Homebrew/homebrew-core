class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.10/htslib-1.10.tar.bz2"
  sha256 "7ae44dd9faeb4c4293e9bb4815164ac28c6c6fae81fed4791df2fa878f57a972"

  bottle do
    cellar :any
    sha256 "dbacdef5228a255b0c1c3def472eacabebe2785143683f56dce4ae2df12ef601" => :catalina
    sha256 "7ed8777a2c6aa4bf909d9adb9e41e7b3c9c3f249d6ba6b17ca23b0ef65400b28" => :mojave
    sha256 "330fb579bea2afe187a93b02efb826349efd8b4fc1ffe59b03c812adfece73f8" => :high_sierra
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
