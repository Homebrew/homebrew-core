class Mpdas < Formula
  desc "C++ client to submit tracks to audioscrobbler"
  homepage "https://www.50hz.ws/mpdas/"
  url "https://www.50hz.ws/mpdas/mpdas-0.4.3.tar.gz"
  mirror "https://github.com/hrkfdn/mpdas/archive/0.4.3.tar.gz"
  sha256 "069e368bde35b2b3bd79439052c863a0f8c3b25ed454b5ab51f84fa6878b674e"
  revision 1
  head "https://github.com/hrkfdn/mpdas.git"

  bottle do
    sha256 "48431521ae8094de8b4aff26b9ad3d0fd2af3f17100e66efe3cda51c933a6101" => :sierra
    sha256 "418c94fd6545efffad07f8583a5c3589ff36ea222854ac1fc25c82beac1195c9" => :el_capitan
    sha256 "236b7a6af73fb604918cc688aca942075ce7c31b68912d5139ea8d290cfe60da" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libmpdclient"

  def install
    system "make", "PREFIX=#{prefix}", "MANPREFIX=#{man1}", "CONFIG=#{etc}", "install"
    etc.install "mpdasrc.example"
  end

  test do
    system bin/"mpdas", "-v"
  end
end
