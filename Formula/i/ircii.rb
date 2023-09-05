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
    rebuild 2
    sha256 arm64_ventura:  "dc7d4b485e4f00ec1fb9750f38110b452bcc9ee777aebc51521bb32b031d3690"
    sha256 arm64_monterey: "e1a64a64f9aab81c8fce589945912aa0c459daff48e65f455a181d0391539b23"
    sha256 arm64_big_sur:  "9daf37b4ec3ed1b47c8ce24d9acffb0a0781f648f97220c09c6100310819344b"
    sha256 ventura:        "17de357ffa8090c0928c6af8e0a1ade72b43c187552bbc3acb82cf98ebf5d65e"
    sha256 monterey:       "bb15fc3ed62c9a10c8555a53cf3ea89d9025a8ed13ba972f9fd78ce7449998cc"
    sha256 big_sur:        "4d2671014e366e382805580bba8c328f20b52a5838701f08619f030f43f58ae1"
    sha256 catalina:       "b621da055243edbf54884b186c1250ef4ab80655e7647aa837d07e523e8e5c1a"
    sha256 x86_64_linux:   "2c88482345ab4bb6ec095d529259fe14768c6cc7b7918883bf94a3e07b62d700"
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
