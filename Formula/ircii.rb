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
    sha256 arm64_monterey: "a1419d881b643569302b00c917754568e78896cf3c96b377dd42610ef29d3932"
    sha256 arm64_big_sur:  "59c85726eb16390bbeac0309702bf21e76116b552fac81ce36d2d4aa20866318"
    sha256 monterey:       "11957edbab37bf2b64e1ed4b92d0539f7d4e71ecd9f511901c5c34786b5d5932"
    sha256 big_sur:        "e7eae3e18034f4b13f64f83d538dae8b421245f03b3bd5c0c080a1a77db5414e"
    sha256 catalina:       "dc265a9d5875eff670c60a9e81bc0185ee74eee142ad09b8f0bc6c20ea663507"
    sha256 mojave:         "758aa15d57d51e9f2c97115e837cd10c9879bfeb46c84823380291a76573f669"
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
