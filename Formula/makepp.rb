class Makepp < Formula
  desc "Drop-in replacement for GNU make"
  homepage "https://makepp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/makepp/2.0/makepp-2.0.tgz"
  sha256 "d1b64c6f259ed50dfe0c66abedeb059e5043fc02ca500b2702863d96cdc15a19"

  bottle do
    sha256 cellar: :any_skip_relocation, catalina:    "0dfbbcc3fafad36964f7e4c0820726c9764d89a9b56aa190a5cfd44cd0a53dc8"
    sha256 cellar: :any_skip_relocation, mojave:      "4420c1b9b7c5e42663c239b7e2c753c1669a1746bd21579c09e82224f5ea9620"
    sha256 cellar: :any_skip_relocation, high_sierra: "8a8cfb0d135e47e4a37bff17d662234a9c1ebb17d82b12013b3a24d0f8f15032"
    sha256 cellar: :any_skip_relocation, sierra:      "d9244cdf9ca16edf5972aa60783ecfd675c581ba3a9b53339593f1fdc355a0ab"
    sha256 cellar: :any_skip_relocation, el_capitan:  "e2d2e0cbb4999b69e9b1de09a75621ad6119f2978b0a86aefd0e63b2ee908203"
    sha256 cellar: :any_skip_relocation, yosemite:    "9ccedb5776a953719caa8cb8154a8dea1e633fca632eee9ff3ef286e4539f0e8"
  end

  disable! date: "2020-12-08", because: :unmaintained

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/makepp", "--version"
  end
end
