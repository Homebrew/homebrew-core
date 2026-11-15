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
    rebuild 1
    sha256 arm64_golden_gate: "13ebbf524835d17fc45426d8c938c6b53ddb2ee80da87a693962183190ed9204"
    sha256 arm64_tahoe:       "8a11c2fa353238c8bc04bb2272e3c3379f7a375b506c3a1a6d25debf57a0e684"
    sha256 arm64_sequoia:     "2f4008ee66119222dc6146102e7fda300ca30a2c1e241f9b4297def808e9fd06"
    sha256 arm64_linux:       "5fca12b00e20b231928fffa60c3ee84024e6a3d4aa5d210c032c6ed42ea5af1e"
    sha256 x86_64_linux:      "ef01fd427bbfc49593060935645b9ce17a1c8a23c90694ddf734d3de0efab623"
  end

  depends_on "openssl@4"

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  deny_network_access!

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
