class Ircii < Formula
  desc "IRC and ICB client"
  homepage "http://www.eterna.com.au/ircii/"
  url "https://ircii.warped.com/ircii-20210314.tar.bz2"
  mirror "https://deb.debian.org/debian/pool/main/i/ircii/ircii_20210314.orig.tar.bz2"
  sha256 "866f2b847daed3d70859f208f7cb0f20b58c0933b2159f7ff92a68c518d393a9"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause",
    "GPL-2.0-or-later",
    "MIT",
    :public_domain,
  ]

  livecheck do
    url "https://ircii.warped.com/"
    regex(/href=.*?ircii[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "06575e2e48874d7f5650fea61b689028f6b7854ba77cd58fe982a3c0b1c66bfa"
    sha256 arm64_big_sur:  "5c643f15576e03070991659ede28ea7bce710f091e79bb99bcd315d3bdf4672f"
    sha256 monterey:       "83e421aa74c85552075cda2c66c98df71e6e6c831eb178ff1557611932054d22"
    sha256 big_sur:        "45c5ac2c7a6ed25595750c5513d11c1c0bec9797680a37b6245d8140ffd1637d"
    sha256 catalina:       "d261b8a30b2430dcd089356e56e4165073d0f6f76b13262220ebae0ccb599fce"
    sha256 x86_64_linux:   "94729a716fd12dbf1b984e8d87c746876dd46e3a5e77ee7ef5513965c78c3d0f"
  end

  depends_on "openssl@3"

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  def install
    ENV.append "LIBS", "-liconv" if OS.mac?
    system "./configure", "--prefix=#{prefix}",
                          "--with-default-server=irc.libera.chat",
                          "--enable-ipv6"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    IO.popen("#{bin}/irc -d", "r+") do |pipe|
      assert_match "Connecting to port 6667 of server irc.libera.chat", pipe.gets
      pipe.puts "/quit"
      pipe.close_write
      pipe.close
    end
  end
end
