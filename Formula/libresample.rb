class Libresample < Formula
  desc "Audio resampling C library"
  homepage "https://ccrma.stanford.edu/~jos/resample/Available_Software.html"
  url "https://deb.debian.org/debian/pool/main/libr/libresample/libresample_0.1.3.orig.tar.gz"
  sha256 "20222a84e3b4246c36b8a0b74834bb5674026ffdb8b9093a76aaf01560ad4815"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "779b21b26d28a7318e67e0444b74ee5782715b523c1f79ba9bdff41c334cd312" => :catalina
    sha256 "7973809674c5ca9dceaf822abaf482c2a8126928140fa056168644b1196005c2" => :mojave
    sha256 "42b971ed75ad6ba1bd6879c2b7cb5fb416706ed184291d12983e46ab6c90a20c" => :high_sierra
    sha256 "b94dc206fa507bcdceb49534740c5c0dff0868a9d9333e4acd8922f22b10c912" => :sierra
    sha256 "ba2446005f2417fa81e5a5963d2273494396f8821ee95fd84ed9825342564598" => :el_capitan
    sha256 "2f58f8b45cd7b6f89f645cb90d3b4f63dd0a28e927713f3a4664c348e3a15a21" => :yosemite
    sha256 "61a8ab0861ce6e6c45632b7235eaf718e4be191fe8c184ba8f065d436681d786" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    lib.install "libresample.a"
    include.install "include/libresample.h"
  end
end
