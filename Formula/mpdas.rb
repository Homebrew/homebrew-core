class Mpdas < Formula
  desc "C++ client to submit tracks to audioscrobbler"
  homepage "https://www.50hz.ws/mpdas/"
  url "https://www.50hz.ws/mpdas/mpdas-0.4.3.tar.gz"
  mirror "https://github.com/hrkfdn/mpdas/archive/0.4.3.tar.gz"
  sha256 "925089a1d395352c27df68b274b33258a09e334e784322e72dc064241aa2e075"
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
  end

  test do
    system bin/"mpdas", "-v"
  end
end
