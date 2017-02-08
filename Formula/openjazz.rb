class Openjazz < Formula
  desc "Open source Jazz Jackrabit engine"
  homepage "http://www.alister.eu/jazz/oj/"
  url "http://www.alister.eu/jazz/oj/OpenJazz-src-160214.zip"
  sha256 "8178731e005188a8e87174af26f767b7a1815c06b3bd9b8156440ecea4d7b10a"

  head "https://github.com/AlisterT/openjazz.git"

  bottle do
    cellar :any
    sha256 "2af3cfc16369b10add552cb8fe84656857473e1f567087cc9b37ddbe1b82049e" => :yosemite
    sha256 "faa962823262bace1d0105d5be10cbebdc5ebb244ebe170ba3b4b4b7ae56afeb" => :mavericks
    sha256 "70f56d799b82522426d011face63f33665af096c0d22f18c432c6d2cae25033e" => :mountain_lion
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
    url "http://image.dosgamesarchive.com/games/jazz.zip"
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
    (bin/"OpenJazz").write <<-EOS.undent
    #!/bin/sh

    exec "#{pkgshare}/OpenJazz" "$@"
    EOS

    resource("shareware").stage do
      pkgshare.install Dir["*"]
    end
  end

  def caveats; <<-EOS.undent
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
