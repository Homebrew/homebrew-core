class Morse < Formula
  desc "QSO generator and morse code trainer"
  homepage "http://www.catb.org/~esr/morse/"
  url "https://gitlab.com/esr/morse-classic/-/archive/2.6/morse-classic-2.6.tar.bz2"
  sha256 "ec44144d52a1eef36fbe0ca400c54556a7ba8f8c3de38d80512d19703b89f615"
  license "BSD-2-Clause"

  # The homepage links to the `stable` tarball but it can take longer than the
  # ten second livecheck timeout, so we check the Git tags as a workaround.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "5af8e1138400c0410e669f190bfc8b780ae1d54152e5e9cba157d4fdc8d73792"
    sha256 cellar: :any,                 arm64_sequoia: "afec0c7b8677d73fb2695f5d6aff98d5e2dfe5b13411de3f4f79dadf7a296994"
    sha256 cellar: :any,                 arm64_sonoma:  "58aebc54714e5305c9b37084625b0462932848995c9cb65e44b6307df937b510"
    sha256 cellar: :any,                 sonoma:        "c49300c884c3b036c4c00f7db535681b09a4bbca76a1c49d37a94a8ac2bd2074"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cd879e547ca150605b72464bf388e6c81e75c27a8b05714c5bd3599a39168d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de0434c6211f07598c07af76d70b457f30a2ceb45bd0fdba0082225b112cf5fa"
  end

  depends_on "pkgconf" => :build
  depends_on "xmlto" => :build
  depends_on "pulseaudio"

  # Apply Debian patch to open a mono stream to fix "pa_simple_Write failed"
  patch do
    url "https://salsa.debian.org/debian-hamradio-team/morse/-/raw/7acc68ab78dc8b634c0c81dc56fee0634fc9fc3b/debian/patches/04fix-pa_simple_write-with-mono-output.patch"
    sha256 "ae37ff290eba510fd52fe8babbe86c3ab56755b3ad5a9b7f9949b6a899b06288"
  end

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
    if OS.mac?
      # Cannot set up pulseaudio on CI runners so just check for error message
      assert_match "Could not initialize audio", shell_output("#{bin}/morse -m brew 2>&1", 1).strip
    else
      assert_equal "-... .-. . .--", shell_output("#{bin}/morse -m brew").strip
    end
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
