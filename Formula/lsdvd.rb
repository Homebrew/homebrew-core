class Lsdvd < Formula
  desc "Read the content info of a DVD"
  homepage "https://sourceforge.net/projects/lsdvd"
  url "https://downloads.sourceforge.net/project/lsdvd/lsdvd/lsdvd-0.17.tar.gz"
  sha256 "7d2c5bd964acd266b99a61d9054ea64e01204e8e3e1a107abe41b1274969e488"
  revision 1

  bottle do
    cellar :any
    sha256 "dedcdf6af7a20307df4b86fd6dee6842031ecc99fcadfcb2691b2a36ecaa2ab6" => :mojave
    sha256 "9a413bfe449780947f185252ad35d6aad1fcee718e561f283ee12a7761267299" => :high_sierra
    sha256 "9ef88f96d637feeaf0b58d1160f0b2a19fd1531083916d89d1c7e09b1e68a1ab" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libdvdcss"
  depends_on "libdvdread"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"lsdvd", "--help"
  end
end
