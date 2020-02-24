class Advancemenu < Formula
  desc "Frontend for AdvanceMAME/MESS"
  homepage "https://www.advancemame.it/menu-readme.html"
  url "https://github.com/amadvance/advancemame/releases/download/advancemenu-2.9/advancemenu-2.9.tar.gz"
  sha256 "c7599da6ff715eb3ad9f7a55973a9aaac2f26740a4e12daf744cf08963d652c1"

  bottle do
    cellar :any
    rebuild 1
    sha256 "cddc2110c8f7a94fff740ebb35d9d48fb5b47ccecbf92eedfc5ee28b28bfdd62" => :catalina
    sha256 "f1f5a182df60bf84339ff741e73dc464b209d87ed50f1b74bc671736eef6e300" => :mojave
    sha256 "a7e1ea0b085ec97b97bcb8f45ecd4221ad626a530a4d8b6dc1f56a3e85b9cf6a" => :high_sierra
  end

  depends_on "sdl"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  conflicts_with "advancemame", :because => "both install `advmenu` binaries"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "LDFLAGS=#{ENV.ldflags}", "mandir=#{man}"
  end

  test do
    system bin/"advmenu", "--version"
  end
end
