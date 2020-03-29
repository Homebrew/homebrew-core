class Advancemenu < Formula
  desc "Frontend for AdvanceMAME/MESS"
  homepage "https://www.advancemame.it/menu-readme.html"
  url "https://github.com/amadvance/advancemame/releases/download/v3.9/advancemame-3.9.tar.gz"
  sha256 "3e4628e1577e70a1dbe104f17b1b746745b8eda80837f53fbf7b091c88be8c2b"

  bottle do
    sha256 "07f9a82231936429257190078d28ec7313b39dfe9ecf3ed9e82b15fbe1615366" => :catalina
    sha256 "36ebf0c6727172fa909b933f801986e483892d5cb10c0a2fb27314880d906bd1" => :mojave
    sha256 "fda952fe67d2c39e57d621b6a1392493a95c8ef62f510f63534f962a97252d26" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "sdl"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  conflicts_with "advancemame", :because => "both install `advmenu` binaries"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "LDFLAGS=#{ENV.ldflags}", "mandir=#{man}"
  end

  test do
    assert_match "Creating AdvanceMENU standard configuration file", shell_output("#{bin}/advmenu --default 2>&1")
  end
end
