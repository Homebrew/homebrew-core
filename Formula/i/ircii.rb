class Ircii < Formula
  desc "IRC and ICB client"
  homepage "http://www.eterna23.net/ircii/"
  url "https://ircii.warped.com/ircii-20240918.tar.bz2"
  mirror "https://deb.debian.org/debian/pool/main/i/ircii/ircii_20240918.orig.tar.bz2"
  sha256 "f4b9b380ba5143261a3ef219abfdef749c44ce4f669908da60bc3997af649ca9"
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
    sha256 arm64_tahoe:   "da95ef083293ba807ee3c65c7d3c8539da6cef6f8a6b4c5596c7268ff7caf794"
    sha256 arm64_sequoia: "8e8fe508af0773e346c196d3ded29a2529e736ae175942b407321556e7ee3d85"
    sha256 arm64_sonoma:  "250efa55d481e553454206dd459b55e825a16f93003e4e96ccb26c9b132c3568"
    sha256 arm64_ventura: "9bba80a660397068c42e2f12d7940ced34bdb253451435ee8f51b6993230bda5"
    sha256 sonoma:        "e9db1fd59f8b31c281a121f1821628780a85e990042cfb8c4ac674ee1b50433b"
    sha256 ventura:       "b3cfde024333fbc46af44fcf09500d7a27369a12eac24f604ba404aca862ca18"
    sha256 arm64_linux:   "c2c74e2ba79a6f4ef96605a4868673c34afb722f71118f6a489bf4c6041df158"
    sha256 x86_64_linux:  "7680b15d1879970be38ec1c55f3e2c99a0381c0cddddf43fd4c66e567340427a"
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
