class Flashrom < Formula
  desc "Identify, read, write, verify, and erase flash chips"
  homepage "https://flashrom.org/"
  url "https://download.flashrom.org/releases/flashrom-v1.3.0.tar.bz2"
  sha256 "a053234453ccd012e79f3443bdcc61625cf97b7fd7cb4cdd8bfbffbe8b149623"
  license "GPL-2.0-or-later"
  head "https://review.coreboot.org/flashrom.git", branch: "master"

  livecheck do
    url "https://download.flashrom.org/releases/"
    regex(/href=.*?flashrom[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e333d7b600ff538511491787f251b2f7ccc5adb83d3cb6d2d8e851cb0b7f383c"
    sha256 cellar: :any,                 arm64_monterey: "146d7682e5d7e4fa3cf903d9bce8e1b644a114e76399fe84e3be506cbabdc3ca"
    sha256 cellar: :any,                 arm64_big_sur:  "01c14e3cdb46c9a2fe4727f07db401ebceb33ff7d71164c11f6937b073aafc36"
    sha256 cellar: :any,                 ventura:        "e9a865790102fb834ff6cd092e9e27ac706c6e8dee9f97aa2490a20324c29836"
    sha256 cellar: :any,                 monterey:       "66d6161255682536219857be846944b006f675b1e068514b77380af8e9f5d985"
    sha256 cellar: :any,                 big_sur:        "613523b5edc4a0c6c575bdfd41346e7abec90318713d53a013fd0dc48912d5a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04d75c009bc6a07b25080087cb9ca12df91bcf67db422e607fe5e78c0a641ecc"
  end

  depends_on "pkg-config" => :build
  depends_on "libftdi"
  depends_on "libusb"

  # no DirectHW framework available
  on_macos do
    on_intel do
      patch :DATA
    end
  end

  resource "DirectHW" do
    url "https://github.com/PureDarwin/DirectHW/archive/refs/tags/DirectHW-1.tar.gz"
    sha256 "14cc45a1a2c1a543717b1de0892c196534137db177413b9b85bedbe15cbe4563"
  end

  def install
    ENV["CONFIG_RAYER_SPI"] = "no"
    ENV["CONFIG_ENABLE_LIBPCI_PROGRAMMERS"] = "no"

    # install DirectHW for osx x86 builds
    if OS.mac? && Hardware::CPU.intel?
      (buildpath/"DirectHW").install resource("DirectHW")
      ENV.append "CFLAGS", "-I#{buildpath}"
    end

    system "make", "DESTDIR=#{prefix}", "PREFIX=/", "install"
    mv sbin, bin
  end

  test do
    system bin/"flashrom", "--version"

    output = shell_output("#{bin}/flashrom --erase --programmer dummy 2>&1", 1)
    assert_match "No EEPROM/flash device found", output
  end
end

__END__
diff --git a/Makefile b/Makefile
index a8df91f..a178074 100644
--- a/Makefile
+++ b/Makefile
@@ -834,7 +834,7 @@ PROGRAMMER_OBJS += hwaccess_physmap.o
 endif

 ifeq (Darwin yes, $(TARGET_OS) $(filter $(USE_X86_MSR) $(USE_X86_PORT_IO) $(USE_RAW_MEM_ACCESS), yes))
-override LDFLAGS += -framework IOKit -framework DirectHW
+override LDFLAGS += -framework IOKit
 endif

 ifeq (NetBSD yes, $(TARGET_OS) $(filter $(USE_X86_MSR) $(USE_X86_PORT_IO), yes))
