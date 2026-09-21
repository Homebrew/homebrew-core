class Adns < Formula
  desc "C/C++ resolver library and DNS resolver utilities"
  homepage "https://www.chiark.greenend.org.uk/~ian/adns/"
  url "https://www.chiark.greenend.org.uk/~ian/adns/ftp/adns-1.7.0.tar.gz"
  sha256 "2ffabc4853bb1c70e29e6585ea15dfef8b2bdb86b6ccaad0a3b8c92b5d526d1b"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.0-or-later"]
  head "https://www.chiark.greenend.org.uk/ucgi/~ianmdlvl/githttp/adns.git", branch: "master"

  livecheck do
    url "https://www.chiark.greenend.org.uk/~ian/adns/ftp/"
    regex(/href=.*?adns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f37840ca2880b5bef50a47f5f4b2ac273dd37d268e88bbf5de618fd9334d803e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9f97460489cdf303f9b431a72e96666fe38f4a4d0de5370c75bb1b960fcaef5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "77170c7a123efa6a5717a542e8b63c8d407004fbcfe212a56e58cc413691449b"
    sha256 cellar: :any,                 arm64_linux:       "ef404a0c8f90b593f1b14d709cfeb94b3d8460443a706a7127e08b81951f924f"
    sha256 cellar: :any,                 x86_64_linux:      "cecb74f68c64b3517b6cd183f72f8b5e7543fe52e245c9b89d3beffc9e20c01d"
  end

  uses_from_macos "m4" => :build

  # Add missing `<sys/random.h>` header
  patch :DATA

  deny_network_access!

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dynamic"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"adnsheloex", "--version"
  end
end

__END__
diff --git a/src/nextid.c b/src/nextid.c
index c33e175..02508ea 100644
--- a/src/nextid.c
+++ b/src/nextid.c
@@ -21,6 +21,7 @@
  */
 
 #include "internal.h"
+#include <sys/random.h>
 
 /* common, error handling */
