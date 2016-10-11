class Makepp < Formula
  desc "Drop-in replacement for GNU make"
  homepage "http://makepp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/makepp/2.0/makepp-2.0.tgz"
  sha256 "d1b64c6f259ed50dfe0c66abedeb059e5043fc02ca500b2702863d96cdc15a19"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9244cdf9ca16edf5972aa60783ecfd675c581ba3a9b53339593f1fdc355a0ab" => :sierra
    sha256 "e2d2e0cbb4999b69e9b1de09a75621ad6119f2978b0a86aefd0e63b2ee908203" => :el_capitan
    sha256 "9ccedb5776a953719caa8cb8154a8dea1e633fca632eee9ff3ef286e4539f0e8" => :yosemite
    sha256 "d54e884aac7589f363d2c67920c87861878777a59771cd2457ed86053cf6e6b8" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end
end
