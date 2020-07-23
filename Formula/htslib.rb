class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.10.2/htslib-1.10.2.tar.bz2"
  sha256 "e3b543de2f71723830a1e0472cf5489ec27d0fbeb46b1103e14a11b7177d1939"
  revision 1

  bottle do
    cellar :any
    sha256 "4db003ad760c84dbe70dfcd866a32066a4d93980eab12526f69f53e0052d84a6" => :catalina
    sha256 "b4282ee3f330a894e68a0141b13b7fc1327d92a5319a95f5a8107a401e57ece5" => :mojave
    sha256 "507db470fc6cb7d97b06f0efff270fe2063d25143bdc09623135c4876474b3c3" => :high_sierra
  end

  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  # patch to allow htslib to work with newer libcurls that are packaged by homebrew
  # see https://github.com/samtools/htslib/pull/1105
  # this patch should be deleted on next release of htslib
  patch do
    url "https://github.com/samtools/htslib/commit/c7c7fb56dba6f81a56a5ec5ea20b8ad81ce62a43.patch?full_index=1"
    sha256 "2d0244d066c07774ab6e372d0bfdd259fd7f64a918eb9595eae6c201e66db594"
  end

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
