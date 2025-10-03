class Morse < Formula
  desc "QSO generator and morse code trainer"
  homepage "http://www.catb.org/~esr/morse/"
  # reported the artifact issue on the project page, https://gitlab.com/esr/morse-classic/-/issues/1
  url "https://gitlab.com/esr/morse-classic/-/archive/2.6/morse-classic-2.6.tar.bz2"
  sha256 "ec44144d52a1eef36fbe0ca400c54556a7ba8f8c3de38d80512d19703b89f615"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?morse[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "1dceecbf27b161c7e25af6c3aa46a4be23084c129677c5da4a45b284df152a09"
    sha256 cellar: :any,                 arm64_sequoia:  "d2d07a8df0960df4b556fc6dca7f17bdc71f430cdc0dccf22911b444ecc2a5bd"
    sha256 cellar: :any,                 arm64_sonoma:   "0286b2ad85c1add1655abfb88976233c98db5050e38d9d3995c1adb9c9a10a1e"
    sha256 cellar: :any,                 arm64_ventura:  "2474d8763e32b94635781a29c7ead023710fb0186a9d21fb22cfcd7a8d22e4eb"
    sha256 cellar: :any,                 arm64_monterey: "b11f64cb45004eba37bf06e0d367e71b6f088fe7d05e80019125c325a48fcd9d"
    sha256 cellar: :any,                 sonoma:         "6892afd65e72497a1fc11d849031e2ea034ffbd41f644a018ec14d0a1a110bfe"
    sha256 cellar: :any,                 ventura:        "6b25ce35c70900babe4699533e2161b58b7b73cb9349821e9043b5aa01f95e71"
    sha256 cellar: :any,                 monterey:       "56d73fcfdfaa67270047046e7785881149585063ea71f9d5da7e32b42f3fcd61"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "179f572cabeb59bddaa4fe3b5b8dad88130be7f98f768804dff18dc65a96671a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f8504ea84011770dbba7831cfb9a35742be9efc2d849657385fb7a68e7ade6f"
  end

  depends_on "pkgconf" => :build
  depends_on "xmlto" => :build
  depends_on "pulseaudio"

  patch :DATA

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    ENV["CC"] = "#{ENV.cc} -Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # Build can fail if morse.1 and QSO.1 run simultaneously
    ENV.deparallelize

    system "make", "all"
    bin.install %w[morse QSO]
    man1.install %w[morse.1 QSO.1]
  end

  test do
    # Fails in Linux CI with "pa_simple_Write failed"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "Could not initialize audio", shell_output("#{bin}/morse -- 2>&1", 1)
  end
end

__END__
diff --git a/Makefile b/Makefile
index 8bdf1f6..df39baa 100644
--- a/Makefile
+++ b/Makefile
@@ -28,8 +28,8 @@
 #DEVICE = X11
 #DEVICE = Linux
 #DEVICE = OSS
-DEVICE = ALSA
-#DEVICE = PA
+#DEVICE = ALSA
+DEVICE = PA

 VERSION=$(shell sed -n <NEWS '/^[0-9]/s/:.*//p' | head -1)
