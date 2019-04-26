class Libfixbuf < Formula
  desc "Implements the IPFIX Protocol as a C library"
  homepage "https://tools.netsa.cert.org/fixbuf/"
  url "https://tools.netsa.cert.org/releases/libfixbuf-2.3.1.tar.gz"
  sha256 "2ba7877c5b09c120a20eb320d5d9e2ac93520c8308624eac3064aaece239bad3"

  bottle do
    sha256 "e880e6bba9e44a26a962fc5dcec07b1b1083c23d46036f39bc330e4b75616c12" => :mojave
    sha256 "ae3d11e94915eb3d2bb48061d0d3cc8ec7749cb833137a9648190c486850a5d7" => :high_sierra
    sha256 "fab9df238cb38319886f2ecd02d724fd481c1634d9d35ef5d616337ad1c1ab87" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end
end
