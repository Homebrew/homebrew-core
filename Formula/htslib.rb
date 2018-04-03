class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.8/htslib-1.8.tar.bz2"
  sha256 "c0ef1eec954a98cc708e9f99f6037db85db45670b52b6ab37abcc89b6c057ca1"

  bottle do
    cellar :any
    sha256 "9bbd0f83d2f5e7ea2d9889bfabb6f47aba7ea5d9dfb9070f0566bd7bba9e4f32" => :high_sierra
    sha256 "5ec146ac61a5e7cff8c8f71f3a4ddf64871d4dd3dcfd043e4b5630292abe39fa" => :sierra
    sha256 "b122c09b37bf213d9eca36ae852011af1c56210d755dc44103ca11882b4a9b7d" => :el_capitan
  end

  depends_on "xz"

  def install
    system "./configure", "--prefix=#{prefix}"
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
