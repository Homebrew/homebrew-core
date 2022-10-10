class Epic5 < Formula
  desc "Enhanced, programmable IRC client"
  homepage "http://www.epicsol.org/"
  url "http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/epic5-2.1.12.tar.xz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/epic5/epic5-2.1.12.tar.xz"
  sha256 "c89ae4fc014ddcf0084b748e22f47b46a85ab1ac9bf0b22560360ba8626b6da6"
  license "BSD-3-Clause"
  revision 1
  head "http://git.epicsol.org/epic5.git", branch: "master"

  livecheck do
    url "http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/"
    regex(/href=.*?epic5[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "70c661fdc5cdabd5a31c829e4bf0c62a82d50864cde553b9ea5c62e1e7ca6159"
    sha256 arm64_big_sur:  "13bd99d0a891e42b3ffa9cd4c1f091dde0162332789a87ab61190500b9d3750c"
    sha256 monterey:       "2f66371a7498313027cc1bffddfcc0628fa6fdc0b868df61f705e8763cbfc0c7"
    sha256 big_sur:        "d55dc10d6761ab6906681aac69d3b064760b4ec0370f0280d3360a0f51727307"
    sha256 catalina:       "7f7d4e9c48b225f24987c719d2aa9aa80e21a7b0191c4bb7a69199e1740b08c1"
    sha256 x86_64_linux:   "7058b9559a17231ff6824d0f8e94bc003270ec72ece898188e4ba544fe3d07f3"
  end

  depends_on "openssl@3"

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  def install
    system "./configure", *std_configure_args,
                          "--mandir=#{man}",
                          "--with-ipv6",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    connection = fork do
      exec bin/"epic5", "irc.freenode.net"
    end
    sleep 5
    Process.kill("TERM", connection)
  end
end
