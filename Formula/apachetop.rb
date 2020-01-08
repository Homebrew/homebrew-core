class Apachetop < Formula
  desc "Top-like display of Apache log"
  homepage "https://web.archive.org/web/20170809160553/freecode.com/projects/apachetop"
  url "https://deb.debian.org/debian/pool/main/a/apachetop/apachetop_0.18.4.orig.tar.gz"
  sha256 "1cbbfd1bf12275fb21e0cb6068b9050b2fee8c276887054a015bf103a1ae9cc6"

  bottle do
    cellar :any_skip_relocation
    sha256 "0876195a3ce545c11cd9a7bc9f348572bee2b0fe30d053cb0398423c2eb7743c" => :catalina
    sha256 "90dcbabb24c87f8cc0571a0cf1e6e559019c3af7f9502f09c4a0f98b7dafa038" => :mojave
    sha256 "f11376a3c66e0c038d0bedb25e105414a27a26a766f1b138e2cd9fdac44e4e4f" => :high_sierra
    sha256 "5acd00b752d960b8dc7250e841ccf8f0dd457d184b0d7c3a8e257a531cf01ae1" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-logfile=/var/log/apache2/access_log"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/apachetop -h 2>&1", 1)
    assert_match "ApacheTop v#{version}", output
  end
end
