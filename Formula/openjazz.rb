class Openjazz < Formula
  desc "Open source Jazz Jackrabit engine"
  homepage "http://www.alister.eu/jazz/oj/"
  url "https://github.com/AlisterT/openjazz/archive/20190106.tar.gz"
  sha256 "27da3ab32cb6b806502a213c435e1b3b6ecebb9f099592f71caf6574135b1662"
  license "GPL-2.0"
  head "https://github.com/AlisterT/openjazz.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e9997f65f26d10adbf4ed7028f9a0c624b6000e586b529cc2969ef2ba2c0b859"
    sha256 cellar: :any,                 arm64_big_sur:  "0c93957029786455fa5dcaa7441408e0f1f5e4e5503019b056959638f54b082a"
    sha256 cellar: :any,                 monterey:       "2140149d9e672b0934b291de6aff920e6100f7e4dc99fa9def06c39423981c3e"
    sha256 cellar: :any,                 big_sur:        "f38330100102887cadfe0929d42e4f61b743e3a9e8417a78d3da7c9bf620217b"
    sha256 cellar: :any,                 catalina:       "9f6f4144256364824f4c16c430aaa738e6675f031f8bd7eaa76fa33d4d367430"
    sha256 cellar: :any,                 mojave:         "06066b8e0bf792d894ceb24ed1ec5409ad896982db87ecab8c07278eabdc3f98"
    sha256 cellar: :any,                 high_sierra:    "b5684fc3faa686f06f9600e8c4bb9c787c7cbf3eb100fc8a64a52502e84ce2ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5695fc1b02ff050deb2b42bff183e7fbbdf51ad4a679bf65d64552cf49f1ca63"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libmodplug"
  depends_on "sdl"

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
