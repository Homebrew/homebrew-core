class Lame < Formula
  desc "High quality MPEG Audio Layer III (MP3) encoder"
  homepage "https://lame.sourceforge.io/"
  url "https://downloads.sourceforge.net/sourceforge/lame/lame-3.100.tar.gz"
  sha256 "ddfe36cab873794038ae2c1210557ad34857a4b6bdc515785d1da9e175b1da1e"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7a83459b430c68aa7388b4b9b569e33bd8d8b8b14debb2b7aaed315b5ef21ff9" => :high_sierra
    sha256 "687dd6b97e6c8d385b55eb4ace546b52bb584a7c56516f97a144ff99e29abdc3" => :sierra
    sha256 "fc7884b76f15e5feebef087b4597e1f142b9aed83274e989c1ca959edb294454" => :el_capitan
    sha256 "064e13206ca4f731d919f89adb480b4a83116a4374f5aa6d205528838364ca7b" => :yosemite
    sha256 "43ee3550ab5ce2c5e9b4e8adfedc197b5ffbf252320d46de97cd6a7133ddd16f" => :mavericks
    sha256 "db743baefa0ec1b0f8c00df4728536418916c4d42c71c548dc43d43a1b24b523" => :mountain_lion
  end

  def install
    # Fix undefined symbol error _lame_init_old
    # https://sourceforge.net/p/lame/mailman/message/36081038/
    inreplace "include/libmp3lame.sym", "lame_init_old\n", ""

    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-nasm"
    system "make", "install"
  end

  test do
    system "#{bin}/lame", "--genre-list", test_fixtures("test.mp3")
  end
end
