class Openjazz < Formula
  desc "Open source Jazz Jackrabit engine"
  homepage "http://www.alister.eu/jazz/oj/"
  url "http://www.alister.eu/jazz/oj/OpenJazz-src-160214.zip"
  sha256 "8178731e005188a8e87174af26f767b7a1815c06b3bd9b8156440ecea4d7b10a"

  head "https://github.com/AlisterT/openjazz.git"

  bottle do
    cellar :any
    sha256 "f761bace57cb19a1505b252736ab9c1ea069000858a294b0aad9e35679fe9829" => :high_sierra
    sha256 "e5cecf43b5022ad8ed9eecef1ad221c5fcda9f7ee346c3543ad665d082c226aa" => :sierra
    sha256 "35720ec4dc158b49f9b537033a72c4ca53a529b68de5ca577ff0e8df4ae102ab" => :el_capitan
    sha256 "557b67389c325c2377555fd2fd6495acab7df376d03db2ab8cfa7d539c1da4ed" => :yosemite
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
