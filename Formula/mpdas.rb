class Mpdas < Formula
  desc "C++ client to submit tracks to audioscrobbler"
  homepage "https://www.50hz.ws/mpdas/"
  url "https://www.50hz.ws/mpdas/mpdas-0.4.4.tar.gz"
  mirror "https://github.com/hrkfdn/mpdas/archive/0.4.4.tar.gz"
  sha256 "b262a009ba5194bba2e140eade22c9182cdeac8bfb19de250734f8693e0b0d27"
  head "https://github.com/hrkfdn/mpdas.git"

  bottle do
    sha256 "d7d022e04c89320ccd4d23fb573a0c8e88a1f19b7b7b2c17a66004dedd82ee44" => :sierra
    sha256 "cf32500f4ba5e42ccc6b70ebae7e3d698ebe4e87bea81d96d46e38e98e4e9aed" => :el_capitan
    sha256 "31e4052c9d045dfcc44abe3ff78deef83a90d170b895374ea021904b7237fccd" => :yosemite
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
