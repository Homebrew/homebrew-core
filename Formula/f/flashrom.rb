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
    sha256 cellar: :any,                 arm64_sonoma:   "9f3d686bd756e4422c5f9122dab96f43719645604b7c409d1dd9cfb8d439edaf"
    sha256 cellar: :any,                 arm64_ventura:  "6d5089b69b8f9d2ccb3da22940ae48d2c4edc09944d4b2be53886e6d8b4929f3"
    sha256 cellar: :any,                 arm64_monterey: "2f7bfb24f1c0cbbd4d48dfc0ccccaf04970f7c65fbf263273e518ac656909e49"
    sha256 cellar: :any,                 arm64_big_sur:  "4f7f73b3a916f6987e91be89cf333c212cb77896b51e2b0db3a243bfef6d104c"
    sha256 cellar: :any,                 sonoma:         "e7c3d3603e37ff69e0deb4f0f877217eb747712b0993f6e413524604d37ce946"
    sha256 cellar: :any,                 ventura:        "4ff89489acba2e2d05a44e2bfd13ba321e97adfe9a75c67c239b48d99fdb189d"
    sha256 cellar: :any,                 monterey:       "ea25d355f9065255c13e1e76a6575d81a4050bf926ff5f78f4f0faae1216af9a"
    sha256 cellar: :any,                 big_sur:        "f731416fcea36016d9e33999354a6e83ac81e5772a755847daaf66e1fe8f6067"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e3fee5b882f6f5d28f9eab9364727ed69ab9938d9e8f087cd96eee494bdedb2"
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
