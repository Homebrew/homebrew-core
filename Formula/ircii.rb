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
    sha256 arm64_big_sur: "a2cd8fdd4ad9a08296a510e61772422d95ef1e047405c79d613a4e46ce4e68e3"
    sha256 big_sur:       "5fa9235fe1b9f86202dabe7b7a62a0e5fc0007e7f211d50ce04c5574dba30af0"
    sha256 catalina:      "fea5e21aa100bda1104f1d4947376e9af68be118caf89d8b9468b51cbd2059b4"
    sha256 mojave:        "95424df7e321088386df0d493fdc9a29c0f1955201ce0ce6ba9640a6c9678a9e"
    sha256 high_sierra:   "ff375e444386f89ee0ae5f3aa3b6f38bfaa8818c3cd2db8065669f8a0f7d0165"
    sha256 sierra:        "d0739ce549eb581ca3bb13de8c3aa164657235814e3c1edb2a050fde5dbf24f2"
  end

  depends_on "openssl@1.1"

  def install
    ENV.append "LIBS", "-liconv"
    system "./configure", "--prefix=#{prefix}",
                          "--with-default-server=irc.freenode.net",
                          "--enable-ipv6"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    IO.popen("#{bin}/irc -d", "r+") do |pipe|
      assert_match "Connecting to port 6667 of server irc.freenode.net", pipe.gets
      pipe.puts "/quit"
      pipe.close_write
      pipe.close
    end
  end
end
