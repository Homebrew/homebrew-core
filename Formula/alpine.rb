class Alpine < Formula
  desc "News and email agent"
  homepage "http://alpine.x10host.com/alpine/release/"
  url "http://alpine.x10host.com/alpine/release/src/alpine-2.24.tar.xz"
  sha256 "651a9ffa0a29e2b646a0a6e0d5a2c8c50f27a07a26a61640b7c783d06d0abcef"
  license "Apache-2.0"
  head "https://repo.or.cz/alpine.git"

  livecheck do
    url :homepage
    regex(/href=.*?alpine[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "bc7e92be45c91c784791a4be2cc2569bed0b686d132f4cdfd0d0233be091643d" => :big_sur
    sha256 "273db81b08b89a37f782da98e32134526682146c05221bfa230bfbf63220f899" => :arm64_big_sur
    sha256 "8a856082da848d13cc4019f3bed974e896144b0cf192125285e20a7250a72295" => :catalina
    sha256 "43533b14f530c72a3f89dbaebf2c4efcd66c8c7fc89349e56d714ff15f2af02e" => :mojave
    sha256 "bed10deca1df682e23ffec4b21af9f837db1dbf011879ab0df579efc81116db1" => :high_sierra
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
