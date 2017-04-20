class Nesemu2 < Formula
  desc "Cycle accurate NES emulator"
  homepage "http://www.nesemu2.com/"
  url "https://github.com/holodnak/nesemu2.git", :revision => "5173f08fda3ad313ad494d4c67f8b3aed18e4e59"
  version "0.6.1+20140930"
  head "https://github.com/holodnak/nesemu2.git"

  bottle do
    cellar :any
    sha256 "b5e129f5258a72d05f9a8bec4db59b26328fe556b497273ae9d22e31f65e88ee" => :sierra
    sha256 "84e8ce17829e03cd96982d0b3bf305ac46905dec81bd65beefd4d13eaa4c9fd9" => :el_capitan
    sha256 "5029f5ea2c96e0fb1b7f3f0898a5b42003e8db44f65aebf954a32265afc132f5" => :yosemite
  end

  depends_on "wla-dx" => :build
  depends_on "sdl"

  def install
    inreplace "make/sources.make", "-framework SDL", "-lSDL"
    inreplace "source/misc/config.c", %r{/usr(/share/nesemu2)}, "#{HOMEBREW_PREFIX}\\1"
    bin.mkpath
    system "make", "install", "INSTALLPATH=#{bin}", "DATAPATH=#{pkgshare}"
  end

  test do
    system "#{bin}/nesemu2", "--mappers"
  end
end
