class Openjazz < Formula
  desc "Open source Jazz Jackrabit engine"
  homepage "http://www.alister.eu/jazz/oj/"
  url "https://github.com/AlisterT/openjazz/archive/20190106.tar.gz"
  sha256 "27da3ab32cb6b806502a213c435e1b3b6ecebb9f099592f71caf6574135b1662"
  license "GPL-2.0"
  revision 1
  head "https://github.com/AlisterT/openjazz.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "112a6ec8803fa3672de7508518f1b055d7f0302c5e998e850fd3a10b008785ac"
    sha256 cellar: :any,                 arm64_monterey: "c6027acbe964bd7a83d604d812bf5a43078fcd34dd2ed43db595fea85b2e842a"
    sha256 cellar: :any,                 arm64_big_sur:  "7cddbce5a824cfe34e1fd75de8974522d3b011a53c9584052f0b27e79dfc79ca"
    sha256 cellar: :any,                 ventura:        "ac798949ec631497175402c544182e31d47884dcc00e43fb6b7bcfbf96bcf9b4"
    sha256 cellar: :any,                 monterey:       "5239dbf6629d348f81a7466b0bd8d92dbc222decdc304091bf71e545b49bb9bb"
    sha256 cellar: :any,                 big_sur:        "85d31ef9c357d5f3755fcbcb123e93a71f26b2549458ab97c9f3f22975372cfa"
    sha256 cellar: :any,                 catalina:       "b9948afd1fcc825a94787e97bbc964140268ac5c5ee1a76ac1113835869b4e96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a50f5226a5b83bd7f316b4f1546124fcf1b84cb99a18909a6e9551662a5a17b1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libmodplug"
  depends_on "sdl12-compat"

  uses_from_macos "zlib"

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

  def caveats
    <<~EOS
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
