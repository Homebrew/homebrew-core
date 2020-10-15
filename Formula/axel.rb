class Axel < Formula
  desc "Light UNIX download accelerator"
  homepage "https://github.com/eribertomota/axel"
  url "https://github.com/axel-download-accelerator/axel/releases/download/v2.17.9/axel-2.17.9.tar.xz"
  sha256 "f1364d9b55d435efc6d32218097a50a63be7b1300138e698133cf19ad3aa3a54"
  license "GPL-2.0"
  head "https://github.com/eribertomota/axel.git"

  bottle do
    cellar :any
    sha256 "8c4c87ce64a4aaa3691e965a7c5843503f80d348f5d17b0e9d1840c45bbc1aaf" => :catalina
    sha256 "e1ab7026adcf06373662caad04dbc1d93b5fcabb40ff79b6bbba466e0f6d8da4" => :mojave
    sha256 "d27855f8ffa19450a2ba4b54a6338105004f342e85527efaa074d67d245af943" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "openssl@1.1"

  def install
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
