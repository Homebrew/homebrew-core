class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "http://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.6/htslib-1.6.tar.bz2"
  sha256 "9588be8be0c2390a87b7952d644e7a88bead2991b3468371347965f2e0504ccb"
  revision 1

  bottle do
    cellar :any
    sha256 "15c9481d899d77e7d7eeb5c2d2cac09930fef9b28409ec9ea3ab57ec9cc70e87" => :high_sierra
    sha256 "35a9e6c69ed762ee9d5ba2966a484f3a13557dbf23ef897fee6ba7d6f9db5659" => :sierra
    sha256 "5fe4d1a962dd98c9c0497fa88da33f493fdec868a25e531def7c5506424571d0" => :el_capitan
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
