class Alpine < Formula
  desc "News and email agent"
  homepage "http://repo.or.cz/alpine.git"
  url "https://ftp.osuosl.org/pub/blfs/conglomeration/alpine/alpine-2.21.tar.xz"
  mirror "https://fossies.org/linux/misc/alpine-2.21.tar.xz"
  sha256 "6030b6881b8168546756ab3a5e43628d8d564539b0476578e287775573a77438"

  bottle do
    rebuild 1
    sha256 "86c4bb588e6c99a856b665d7643cf8ad699c9add68f7301db804085533480cd8" => :high_sierra
    sha256 "8d0c2b6cd5b91cb904f1ddebe8b5ba27f1c2db50fe26db9a40a8131943abe2b5" => :sierra
    sha256 "a3385e12f96372323504cf50f32b7a045a24e90d0b767ed9be98fdf705d4d65b" => :el_capitan
    sha256 "5b57214d7c4603dea4081f4aa8edee42c148a7daad1ed1fd881d4fb01a28d778" => :yosemite
  end

  depends_on "openssl"

  def install
    ENV.deparallelize

    args = %W[
      --disable-debug
      --with-ssl-dir=#{Formula["openssl"].opt_prefix}
      --with-ssl-certs-dir=#{etc}/openssl
      --prefix=#{prefix}
      --with-passfile=.pine-passfile
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/alpine", "-supported"
  end
end
