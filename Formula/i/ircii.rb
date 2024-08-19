class Ircii < Formula
  desc "IRC and ICB client"
  homepage "http://www.eterna23.net/ircii/"
  url "https://ircii.warped.com/ircii-20240111.tar.bz2"
  mirror "https://deb.debian.org/debian/pool/main/i/ircii/ircii_20240111.orig.tar.bz2"
  sha256 "acb9351d9215c783111ad118ab2a1d3ac27f96e53db9bdc685e5dde1c14fd95d"
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
    sha256 arm64_sonoma:   "abb7c5038b0d96a37d249ca0dd4f64ecf76f76b85849d6a9981577ce88ea2c8e"
    sha256 arm64_ventura:  "035ffb6101cca1e95d9331d6887c70e7b15f2aeeade6572fdae30c803aa9bf7e"
    sha256 arm64_monterey: "694c2884b8beaa9c03933499fda1140f421a9527ee7017f8e5063d8feec7da36"
    sha256 sonoma:         "31df637946b965d07b2c240f382a3496eb8f8e96fb5ea6e29712648cbe4c44df"
    sha256 ventura:        "0b26898ec18c93d737d05a5ddc78f9a4c617686472d32484d78ef22cc9ca1d08"
    sha256 monterey:       "1513fc8051263bde7bbf4aa0bb81ded72c8d89ce70331efde8d648896539df3a"
    sha256 x86_64_linux:   "e47af1b036ee325428beee16be3859e3ccd5f14f383d510996ae90e21aae241a"
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
