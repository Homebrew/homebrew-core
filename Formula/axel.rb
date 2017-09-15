class Axel < Formula
  desc "Light UNIX download accelerator"
  homepage "https://github.com/eribertomota/axel"
  url "https://github.com/axel-download-accelerator/axel/archive/v2.14.tar.gz"
  sha256 "a2bf0859380347bcfbdec1d34322f609f0b883e107d3bf5c06001bcc6a8136ad"
  head "https://github.com/eribertomota/axel.git"

  bottle do
    sha256 "b666fe67c6a87833cd429b4ccc8e0a97ad83e57f32aaf2e8843bf696ebfab3f0" => :high_sierra
    sha256 "36fbb5df1e36855851157671bbe70fe111bce7dab1942aa079ca559aa760296f" => :sierra
    sha256 "8f5041ec250b43c9b481f119f7dabc5f9d3c9312c5b939b76179bedd4036b490" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext"
  depends_on "openssl"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    filename = (testpath/"axel.tar.gz")
    system bin/"axel", "-o", "axel.tar.gz", stable.url
    filename.verify_checksum stable.checksum
    assert File.exist?("axel.tar.gz")
  end
end
