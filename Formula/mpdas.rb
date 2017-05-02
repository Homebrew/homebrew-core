class Mpdas < Formula
  desc "C++ client to submit tracks to audioscrobbler"
  homepage "https://www.50hz.ws/mpdas/"
  url "https://www.50hz.ws/mpdas/mpdas-0.4.2.tar.gz"
  mirror "https://github.com/hrkfdn/mpdas/archive/0.4.2.tar.gz"
  sha256 "8ebdd0518cbdb033fc0578c9ea894d4670de1d67bf2541418cb5f7ac1210db6f"
  head "https://github.com/hrkfdn/mpdas.git"

  bottle do
    sha256 "f1d81b81e0014f9f911201dc13cae7387c19750562e83b77469163ef1b5b6f7c" => :sierra
    sha256 "4410e4e5cb68500e1be00a95dcc47a2e01fa1f23547ebd13827ca9dc9651c6d1" => :el_capitan
    sha256 "d39d4e97dc06435f4a7b326623ecfab8650efa714b6c866af04c514252b3419c" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libmpdclient"

  def install
    system "make", "PREFIX=#{prefix}", "MANPREFIX=#{man1}", "CONFIG=#{etc}", "install"
  end

  test do
    system bin/"mpdas", "-v"
  end
end
