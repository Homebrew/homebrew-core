class Alpine < Formula
  desc "News and email agent"
  homepage "http://alpine.x10host.com/alpine/release/"
  url "http://alpine.x10host.com/alpine/release/src/alpine-2.23.tar.xz"
  sha256 "793a61215c005b5fcffb48f642f125915276b7ec7827508dd9e83d4c4da91f7b"
  license "Apache-2.0"
  head "https://repo.or.cz/alpine.git"

  bottle do
    sha256 "3e775bad34dc730ad9c15e3df30e753842ee542695172362cc648ead05e4d151" => :catalina
    sha256 "5492f86a14779b434ebb069bcef8ae551c93dc8835106d6144699e54191de3bd" => :mojave
    sha256 "f7b9f13b015de8e08ec73b1e4784abc64e5cf01785ef722ffa3d80441248a640" => :high_sierra
  end

  depends_on "openssl@1.1"

  uses_from_macos "ncurses"

  def install
    ENV.deparallelize

    args = %W[
      --disable-debug
      --with-ssl-dir=#{Formula["openssl@1.1"].opt_prefix}
      --with-ssl-certs-dir=#{etc}/openssl@1.1
      --prefix=#{prefix}
      --with-bundled-tools
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/alpine", "-conf"
  end
end
