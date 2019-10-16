class Jbig2enc < Formula
  desc "JBIG2 encoder (for monochrome documents)"
  homepage "https://github.com/agl/jbig2enc"
  url "https://github.com/agl/jbig2enc/archive/0.29.tar.gz"
  sha256 "bfcf0d0448ee36046af6c776c7271cd5a644855723f0a832d1c0db4de3c21280"
  head "https://github.com/agl/jbig2enc.git"

  bottle do
    cellar :any
    sha256 "1c24750a1e84a128012a71d0cc47812c29c32136b31dc9c8a15d71d124701c90" => :catalina
    sha256 "62cbf2c1eab2eb5cfe0060887f96d8408fb05a4214580bef8da8a593962b436d" => :mojave
    sha256 "7431e5b6cf8354ab27bbb7710b2133eb3d381f3c6a30b7143332fba5e7fe82f7" => :high_sierra
    sha256 "53d757dc93193756cc90f94a6ca2f4bad2b77610e5b93d5d74f95899019771be" => :sierra
    sha256 "f903109f6f2da89af11e576c8776f10e16eadb71c0a60edb9f35157b965edd98" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "leptonica"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
