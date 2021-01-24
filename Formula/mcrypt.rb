class Mcrypt < Formula
  desc "Replacement for the old crypt package and crypt(1) command"
  homepage "https://mcrypt.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mcrypt/MCrypt/2.6.8/mcrypt-2.6.8.tar.gz"
  sha256 "5145aa844e54cca89ddab6fb7dd9e5952811d8d787c4f4bf27eb261e6c182098"
  license "GPL-3.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    rebuild 3
    sha256 "284a74fc68549f1479e592b8daf2fd02f695292c5ca0334e7181906803396ceb" => :big_sur
    sha256 "488ff0ff6090f2d58c4bee440fe473f53f3755017bea445e84c94455c235a5b9" => :catalina
    sha256 "55b9b6cb471b312208afddc9bbc9caaf8be6043d2b1cc7e32161633f83e226e5" => :mojave
  end

  # Added automake as a build dependency to update config files in libmcrypt.
  # Please remove in future if there is a patch upstream which recognises aarch64 macos.
  depends_on "automake" => :build
  depends_on "mhash"

  uses_from_macos "zlib"

  resource "libmcrypt" do
    url "https://downloads.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz"
    sha256 "e4eb6c074bbab168ac47b947c195ff8cef9d51a211cdd18ca9c9ef34d27a373e"
  end

  # Patch to correct inclusion of malloc function on OSX.
  # Upstream: https://sourceforge.net/p/mcrypt/patches/14/
  patch :DATA

  def install
    # Work around configure issues with Xcode 12
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

    resource("libmcrypt").stage do
      # Workaround for ancient config files not recognising aarch64 macos.
      %w[config.guess config.sub].each do |fn|
        cp "#{Formula["automake"].opt_prefix}/share/automake-#{Formula["automake"].version.major_minor}/#{fn}", fn
      end

      system "./configure", "--prefix=#{prefix}",
                            "--mandir=#{man}"
      system "make", "install"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--with-libmcrypt-prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      Hello, world!
    EOS
    system bin/"mcrypt", "--key", "TestPassword", "--force", "test.txt"
    rm "test.txt"
    system bin/"mcrypt", "--key", "TestPassword", "--decrypt", "test.txt.nc"
  end
end

__END__
diff --git a/src/rfc2440.c b/src/rfc2440.c
index 5a1f296..aeb501c 100644
--- a/src/rfc2440.c
+++ b/src/rfc2440.c
@@ -23,7 +23,12 @@
 #include <zlib.h>
 #endif
 #include <stdio.h>
+
+#ifdef __APPLE__
+#include <malloc/malloc.h>
+#else
 #include <malloc.h>
+#endif

 #include "xmalloc.h"
 #include "keys.h"
