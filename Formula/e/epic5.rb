class Epic5 < Formula
  desc "Enhanced, programmable IRC client"
  homepage "https://www.epicsol.org/"
  url "https://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/epic5-2.1.13.tar.xz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/epic5/epic5-2.1.13.tar.xz"
  sha256 "31a60b3a0d2bbe7eed38464278f1f7f369e0a05da5197a5cbb8b05a9251d0631"
  license "BSD-3-Clause"
  head "https://git.epicsol.org/epic5.git", branch: "master"

  livecheck do
    url "https://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/"
    regex(/href=.*?epic5[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "6c36777b952d26e56acefec463a8de6c4a6254bba008d58867205d09c312d39a"
    sha256 arm64_ventura:  "7b48f070da4284e3c4a2fb8d5e7480436b815f81c40a9d6fc3ac75c23fc69178"
    sha256 arm64_monterey: "ae10698b79e0b7411984dd89cb91efdfcd158b6dad77ba0b7bc1fd57013624ec"
    sha256 sonoma:         "51f0355fa90ddeb9cda75a4fab9997c3795359e1aeba9414e4f51815c3b142ed"
    sha256 ventura:        "da22cd190847a7302c5d758b4aa26ae7496574df67dd02c9b0a1c3b929e82603"
    sha256 monterey:       "eb652273658fe2015e2cd9b343aa2a4683881d4e61df4fc63bc4645fc6d93491"
    sha256 x86_64_linux:   "9b97fb4e2c588d78b143d2a7bba09a3a67d0e23d05100891b3ee5fdd37a72cce"
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
