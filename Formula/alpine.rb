class Alpine < Formula
  desc "News and email agent"
  homepage "https://alpine.x10host.com/alpine/release/"
  url "https://alpine.x10host.com/alpine/release/src/alpine-2.25.tar.xz"
  sha256 "658a150982f6740bb4128e6dd81188eaa1212ca0bf689b83c2093bb518ecf776"
  license "Apache-2.0"
  revision 1
  head "https://repo.or.cz/alpine.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?alpine[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "3a621168a6ff0929d1c7b96f90dc615d7b2c660ed2265610909d4d9d2936c4d6"
    sha256 arm64_big_sur:  "5e75a022adadeb7ee0dd88e659d942b3b7f0bafcad8187f047003bfb890b4f57"
    sha256 monterey:       "eed2a5fd405f54e9a21d46a47420a958ff39ba766b0dccfa943a1539b91b8161"
    sha256 big_sur:        "05dacac37d8b60fbc1fa0948616ee1d60217d5f875cd565760c8ab15527bad15"
    sha256 catalina:       "d25bcb132a6750abd2f584c19b8297b57e4439cb4f72f9b38678c499e3346096"
    sha256 x86_64_linux:   "e3116ae644715c257f63dc8ce743a0a4b7b79de5375c349db0a9e942b8c1cb5f"
  end

  depends_on "openssl@1.1"

  uses_from_macos "ncurses"
  uses_from_macos "openldap"

  on_linux do
    depends_on "linux-pam"
  end

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
