class Nesemu2 < Formula
  desc "Cycle accurate NES emulator"
  homepage "http://www.nesemu2.com/"
  url "https://github.com/holodnak/nesemu2.git", :revision => "5173f08fda3ad313ad494d4c67f8b3aed18e4e59"
  version "0.6.1+20140930"
  head "https://github.com/holodnak/nesemu2.git"

  bottle do
    cellar :any
    sha256 "c2096564a3a460a3a76d6a982f7c8a46c0ee776696dc7882a3c1d0069f68f5e6" => :el_capitan
    sha256 "47b2366f4edcf4be2a4d0adf3745274195d920b560778c43d3bec3c2ef434e23" => :yosemite
    sha256 "a6a6fb240a1a4d4ae660f35d5cb8253f35ea58e428048760f9882f1e0ab66dd1" => :mavericks
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
