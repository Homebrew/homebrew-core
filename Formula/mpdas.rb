class Mpdas < Formula
  desc "C++ client to submit tracks to audioscrobbler"
  homepage "https://www.50hz.ws/mpdas/"
  url "https://www.50hz.ws/mpdas/mpdas-0.4.4.tar.gz"
  mirror "https://github.com/hrkfdn/mpdas/archive/0.4.4.tar.gz"
  sha256 "b262a009ba5194bba2e140eade22c9182cdeac8bfb19de250734f8693e0b0d27"
  head "https://github.com/hrkfdn/mpdas.git"

  bottle do
    sha256 "111a229f7c41d93993bca09e694c7dac91750f5d964e7024b621dcc1eb775548" => :sierra
    sha256 "d7bf128e8d9570c2a59ad0aacfd7a18d8686eee2e00ce6bbf1594baeb816f77a" => :el_capitan
    sha256 "1f78b379b6f3683ed0c95f62f146f484775a66ecd3afb852d72982aa21e6f13b" => :yosemite
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
