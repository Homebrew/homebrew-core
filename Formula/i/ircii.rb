class Ircii < Formula
  desc "IRC and ICB client"
  homepage "http://www.eterna23.net/ircii/"
  url "https://ircii.warped.com/ircii-20260115.tar.bz2"
  mirror "https://deb.debian.org/debian/pool/main/i/ircii/ircii_20260115.orig.tar.bz2"
  sha256 "a42749250a5eee0a57db3b72fe709bd6b8b81ec76c04c4f89f0878ef899168eb"
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
    sha256 arm64_tahoe:   "f27001eb7472423ac807513f3620dfc50a7abe587b60cae376fcfe1f73bf9d62"
    sha256 arm64_sequoia: "a7dd4d97eaef44799d4d2432bc2929eed4f9466766629e377a84518a4d5b35fe"
    sha256 arm64_sonoma:  "69ea0e7fa6d00012902506b4a8c5169eff23475d842239f2c98652ffb38bbe54"
    sha256 sonoma:        "d7faa252ac267d329da31e1016bfc06f5774e6e628c89b7e9e5050bd3132ba5b"
    sha256 arm64_linux:   "634fd789ba9b7e1c538c0e0c3458f9fa8272ca812047976d10c5b56739a1b8d1"
    sha256 x86_64_linux:  "541eedf1463ed4337afcb37c39f32be57642e9a7cc99777283431be2bdcf0ab3"
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
