class Advancemame < Formula
  desc "MAME with advanced video support"
  homepage "https://www.advancemame.it/"
  url "https://github.com/amadvance/advancemame/releases/download/v3.9/advancemame-3.9.tar.gz"
  sha256 "3e4628e1577e70a1dbe104f17b1b746745b8eda80837f53fbf7b091c88be8c2b"
  license "GPL-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "aa8102392161083a5a0b79bc1e831946522b3e30977c553277a665ed1b52727b"
    sha256 arm64_monterey: "0345ac679c13343cc595026f63d7fa90992935964ae4f949abf6b047ebafd06d"
    sha256 arm64_big_sur:  "8ac0b808eb5358417c5c2aab31e53cca0031a0dd4abb922d7eea5c52622e8f08"
    sha256 ventura:        "c7268e908aabfce9e31170aac2ca2c03664639c23fe7212f8f2885cf4bc66985"
    sha256 monterey:       "f3e7d8dd40e68328a8135949522fe2873a2bd6d8c2271300a74fcb8156e186d3"
    sha256 big_sur:        "8b2d656d506250066ce382a3f538d9476034fa3cf4fcddb87a61ecc84cd4c5d6"
    sha256 catalina:       "6afeb2ebbdbb73b15b5771e33c5da13283b21a8fc26250f0db0cdecd5f41fb9f"
    sha256 x86_64_linux:   "5e416d1d1d749bf88a0a97db5175a22755a200f7db388743b32284ac91b50513"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "sdl2"

  uses_from_macos "expat"
  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-freetype",
                          "--enable-sdl2"
    system "make", "install", "LDFLAGS=#{ENV.ldflags}", "mandir=#{man}", "docdir=#{doc}"
  end

  test do
    system "#{bin}/advmame", "--version"
  end
end
