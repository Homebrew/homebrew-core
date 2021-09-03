class NestopiaUe < Formula
  desc "NES emulator"
  homepage "http://0ldsk00l.ca/nestopia/"
  url "https://github.com/0ldsk00l/nestopia/archive/1.51.1.tar.gz"
  sha256 "6c2198ed5f885b160bf7e22a777a5e139a7625444ec47625cd07a36627e94b3f"
  license "GPL-2.0-or-later"
  head "https://github.com/0ldsk00l/nestopia.git"

  bottle do
    sha256 arm64_big_sur: "788e9075b691d0eb39cd89bd0951fe1510af3dc2838324f8cd7a2a982a80803f"
    sha256 big_sur:       "0d7aa5be67ed9f42a10b902706cdcb3fbbdf2dbf106f590c9a340f702cf675c5"
    sha256 catalina:      "e18051d4add14d42cc3056646dc825679718ef8c92338a411a94a5cd97a4b659"
    sha256 mojave:        "3436bde863064391e63bb7058dd15da362a18470976ed2aebf963d315748834d"
    sha256 x86_64_linux:  "d40f747656a514a1368758ae7c0d2065904b71f55b7fd8ba6b55530c7075ff32"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "fltk"
  depends_on "libarchive"
  depends_on "sdl2"

  uses_from_macos "zlib"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--datarootdir=#{pkgshare}"
    system "make", "install"
  end

  test do
    assert_match(/Nestopia UE #{version}$/, shell_output("#{bin}/nestopia --version"))
  end
end
