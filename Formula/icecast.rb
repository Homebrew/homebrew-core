class Icecast < Formula
  desc "Streaming MP3 audio server"
  homepage "http://www.icecast.org/"
  url "http://downloads.xiph.org/releases/icecast/icecast-2.4.3.tar.gz"
  sha256 "c85ca48c765d61007573ee1406a797ae6cb31fb5961a42e7f1c87adb45ddc592"

  bottle do
    cellar :any
    sha256 "f3660f43ecaab1b126d38916d1bbb4644f395301130e05f80855c3923729fa5a" => :sierra
    sha256 "6904fc3c70e67be98bd73a0cd362f7ae7960b0a8beab1cd924ab84ae42a782a3" => :el_capitan
    sha256 "bfaa0aaec3dec64fdd933bf21913cdfa5883acdc79b58f542072eefb29f12fbf" => :yosemite
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
