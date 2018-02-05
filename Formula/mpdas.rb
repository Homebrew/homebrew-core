class Mpdas < Formula
  desc "C++ client to submit tracks to audioscrobbler"
  homepage "https://www.50hz.ws/mpdas/"
  url "https://www.50hz.ws/mpdas/mpdas-0.4.5.tar.gz"
  sha256 "c9103d7b897e76cd11a669e1c062d74cb73574efc7ba87de3b04304464e8a9ca"
  head "https://github.com/hrkfdn/mpdas.git"

  bottle do
    sha256 "80ebc0ce2fc3fbffb04bc077b7d2d42c6d6b70ed846c97705b4dcbdcf8a866bc" => :high_sierra
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
