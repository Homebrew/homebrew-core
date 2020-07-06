class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20200327.tgz"
  sha256 "466163e8b97c2b7709d00389199add3156bd813f60ccb0335d0a30f2d4a17f99"
  license "LGPL-2.1"

  bottle do
    cellar :any_skip_relocation
    sha256 "23d7541b2fbba5903eafedde0a4182a3bfe11542139e35fa39d308c9464d62c6" => :catalina
    sha256 "73aa99c7e00983a9fdefedd5fec29cd77d2825529aa64a10367b7e9f7bb7e1a1" => :mojave
    sha256 "ef79f4d596a4ebfcb5bde2ac34d0e27e67092263a05b54e110ecc783cfffa4fd" => :high_sierra
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install-full"
  end

  test do
    system "#{bin}/dialog", "--version"
  end
end
