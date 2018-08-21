class Libfixbuf < Formula
  desc "Implements the IPFIX Protocol as a C library"
  homepage "https://tools.netsa.cert.org/fixbuf/"
  url "https://tools.netsa.cert.org/releases/libfixbuf-2.1.0.tar.gz"
  sha256 "d3a0ddf3f693e9421efaa8029c8ff1f78c81c39e77661dc40a05b3515d086fe7"

  bottle do
    cellar :any
    sha256 "c548bdfc48db5ee2b971849ab0bf52c856c96f40de77146f7d796842f8689e99" => :mojave
    sha256 "8c0d314feb7ee75cfe4ef108d15285e6da0fdc7d3c5bcf0dd2a44c059af42bda" => :high_sierra
    sha256 "1cd8bd7f2552f30c27120a4a7ba803a2cc95e6b4d356e5489eda61b59ded001c" => :sierra
    sha256 "92f84cb8a1c4541693ff62533464fe2d04ff6b92c930cb4bb84eab6bac33fedb" => :el_capitan
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
