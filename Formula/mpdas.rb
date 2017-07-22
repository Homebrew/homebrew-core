class Mpdas < Formula
  desc "C++ client to submit tracks to audioscrobbler"
  homepage "https://www.50hz.ws/mpdas/"
  url "https://www.50hz.ws/mpdas/mpdas-0.4.3.tar.gz"
  mirror "https://github.com/hrkfdn/mpdas/archive/0.4.3.tar.gz"
  sha256 "069e368bde35b2b3bd79439052c863a0f8c3b25ed454b5ab51f84fa6878b674e"
  revision 1
  head "https://github.com/hrkfdn/mpdas.git"

  bottle do
    sha256 "aa5c89ffde717e1b266dde5f07db0243e40fe5a609e4f1e335ac282127b5c1dd" => :sierra
    sha256 "90e390e32c5e0e27d91041b64172d91c0aaad08cdadcacb66c2a4b8fa165d9c2" => :el_capitan
    sha256 "102c6569759c6043a2ac29e59423773956c6eed6cc271d748c8da2d83aafbadd" => :yosemite
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
