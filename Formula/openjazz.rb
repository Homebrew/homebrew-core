class Openjazz < Formula
  desc "Open source Jazz Jackrabit engine"
  homepage "http://www.alister.eu/jazz/oj/"
  url "https://github.com/AlisterT/openjazz/releases/download/20180522/openjazz-20180522.tar.xz"
  sha256 "35260066f307ff7e31304907a2a430a20b8d1fa5f90ad2c13275ab3aca337c24"
  head "https://github.com/AlisterT/openjazz.git"

  bottle do
    cellar :any
    sha256 "c0f7a1ea63036f0fe37ddc60e4d161fadc549ef84de52ee1ec88c3c00516608f" => :mojave
    sha256 "25b2ba3440262667196d729f4e88604dfb74e6c9191b92e30d31a241d9aab090" => :high_sierra
    sha256 "ea4d18c72bc6cf5a5393d9f7ed8c40fc66d8355181c93249a926d47029eeae9c" => :sierra
    sha256 "f410241a95a93323d5dd94fd7469b3912ce4105cbe3c3e5483b301f5ea642794" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libmodplug"
  depends_on "sdl"

  # From LICENSE.DOC:
  # "Epic MegaGames allows and encourages all bulletin board systems and online
  # services to distribute this game by modem as long as no files are altered
  # or removed."
  resource "shareware" do
    url "https://image.dosgamesarchive.com/games/jazz.zip"
    sha256 "ed025415c0bc5ebc3a41e7a070551bdfdfb0b65b5314241152d8bd31f87c22da"
  end

  # MSG_NOSIGNAL is only defined in Linux
  # https://github.com/AlisterT/openjazz/pull/7
  patch :DATA

  def install
    # the libmodplug include paths in the source don't include the libmodplug directory
    ENV.append_to_cflags "-I#{Formula["libmodplug"].opt_include}/libmodplug"

    system "autoreconf", "-ivf"
    system "./configure", "--prefix=#{prefix}",
                          "--bindir=#{pkgshare}",
                          "--disable-dependency-tracking"
    system "make", "install"

    # Default game lookup path is the OpenJazz binary's location
    (bin/"OpenJazz").write <<~EOS
      #!/bin/sh

      exec "#{pkgshare}/OpenJazz" "$@"
    EOS

    resource("shareware").stage do
      pkgshare.install Dir["*"]
    end
  end

  def caveats; <<~EOS
    The shareware version of Jazz Jackrabbit has been installed.
    You can install the full version by copying the game files to:
      #{pkgshare}
  EOS
  end
end

__END__
diff --git a/src/io/network.cpp b/src/io/network.cpp
index 8af8775..362118e 100644
--- a/src/io/network.cpp
+++ b/src/io/network.cpp
@@ -53,6 +53,9 @@
		#include <errno.h>
		#include <string.h>
	#endif
+ 	#ifdef __APPLE__
+ 		#define MSG_NOSIGNAL SO_NOSIGPIPE
+    #endif
 #elif defined USE_SDL_NET
	#include <arpa/inet.h>
 #endif
