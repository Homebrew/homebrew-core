class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "http://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.7/htslib-1.7.tar.bz2"
  sha256 "be3d4e25c256acdd41bebb8a7ad55e89bb18e2fc7fc336124b1e2c82ae8886c6"

  bottle do
    cellar :any
    sha256 "8900715ec1050cface2b3921a8085e45980b07282c50794c13a6e0c61d2e1729" => :high_sierra
    sha256 "65781a76f4c67c53695cf99609b0951c832e7ab4703db7f183eae80f3852b4da" => :sierra
    sha256 "9bf6f3fab045f31e497b2e92ba1b2d7f54d4138a8519393b87f45df6f608751a" => :el_capitan
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
