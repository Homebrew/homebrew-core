class Icecast < Formula
  desc "Streaming MP3 audio server"
  homepage "http://www.icecast.org/"
  url "http://downloads.xiph.org/releases/icecast/icecast-2.4.2.tar.gz"
  sha256 "aa1ae2fa364454ccec61a9247949d19959cb0ce1b044a79151bf8657fd673f4f"

  bottle do
    cellar :any
    rebuild 1
    sha256 "27da9615fa078987b9b52d254b2d2edd43f37fb64f7f3ba958740e7890078494" => :sierra
    sha256 "5b80c269400e3f3acd3c46cfc9e771760f9e51128f515f4a96a7a1917d48656e" => :el_capitan
    sha256 "037a9845bedfc65b44bae252a9529771944d3de47f291ca8b1fca01eab9043f2" => :yosemite
    sha256 "0e00235cc643715c86a710ab12c31470e23b6304740ef942406db04b41cdf671" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libogg" => :optional
  depends_on "theora" => :optional
  depends_on "speex"  => :optional
  depends_on "openssl"
  depends_on "libvorbis"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    (prefix+"var/log/icecast").mkpath
    touch prefix+"var/log/icecast/error.log"
  end
end
