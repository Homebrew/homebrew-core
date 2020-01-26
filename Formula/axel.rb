class Axel < Formula
  desc "Light UNIX download accelerator"
  homepage "https://github.com/eribertomota/axel"
  url "https://github.com/axel-download-accelerator/axel/releases/download/v2.17.7/axel-2.17.7.tar.gz"
  sha256 "b05e828fac19acb3bddb7d5e5af69617f29f34aea78dd2045cf30edc834cb4d5"
  head "https://github.com/eribertomota/axel.git"

  bottle do
    cellar :any
    sha256 "acf292cb3e442dba912aa49f6ca641c2863099f649fc52293ea288a6f8dd8f89" => :catalina
    sha256 "07593f73d611d773ee8155c1f26a165ba06f2a716d15a243a4add77983cf3253" => :mojave
    sha256 "c6564d7d46b9201beae836dc36fa6d3b465b51d4c1f7283d498c22145472d6bb" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "openssl@1.1"

  def install
    # Fixes the macOS build by esuring some _POSIX_C_SOURCE
    # features are available:
    # https://github.com/axel-download-accelerator/axel/pull/196
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    filename = (testpath/"axel.tar.gz")
    system bin/"axel", "-o", "axel.tar.gz", stable.url
    filename.verify_checksum stable.checksum
    assert_predicate testpath/"axel.tar.gz", :exist?
  end
end
