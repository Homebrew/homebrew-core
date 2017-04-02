class Mpdas < Formula
  desc "C++ client to submit tracks to audioscrobbler"
  homepage "https://www.50hz.ws/mpdas/"
  url "https://www.50hz.ws/mpdas/mpdas-0.4.2.tar.gz"
  mirror "https://github.com/hrkfdn/mpdas/archive/0.4.2.tar.gz"
  sha256 "8ebdd0518cbdb033fc0578c9ea894d4670de1d67bf2541418cb5f7ac1210db6f"
  head "https://github.com/hrkfdn/mpdas.git"

  bottle do
    cellar :any
    sha256 "90e1ba54b35ed714b5558336793455c2db11e3dab95951cae5b846b0763b1e04" => :sierra
    sha256 "e82e85475795c700ad560280d551c94eac4a7e376eac2848d214e46747023644" => :el_capitan
    sha256 "ce6d4b85c76698e1dd16325d3e4fc0b560a53e5e7a9608aa9060833f7059ff5d" => :yosemite
    sha256 "7844d826d96940c932d89af353e456b17df5cd6ee67627aa51f264d1b713456e" => :mavericks
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
