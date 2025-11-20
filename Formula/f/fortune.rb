class Fortune < Formula
  desc "Infamous electronic fortune-cookie generator"
  homepage "https://www.ibiblio.org/pub/linux/games/amusements/fortune/!INDEX.html"
  url "https://www.ibiblio.org/pub/linux/games/amusements/fortune/fortune-mod-9708.tar.gz"
  mirror "https://src.fedoraproject.org/repo/pkgs/fortune-mod/fortune-mod-9708.tar.gz/81a87a44f9d94b0809dfc2b7b140a379/fortune-mod-9708.tar.gz"
  sha256 "1a98a6fd42ef23c8aec9e4a368afb40b6b0ddfb67b5b383ad82a7b78d8e0602a"
  license "BSD-4-Clause-UC"

  livecheck do
    url "https://www.ibiblio.org/pub/linux/games/amusements/fortune/"
    regex(/href=.*?fortune-mod[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 4
    sha256 arm64_tahoe:    "547b04ec0f01dad4bd92dc49811686b2a6ff159d9040ca79a17f0ee1494cb39d"
    sha256 arm64_sequoia:  "cec3df1e416f4c47846f0fd770bb29bce8185f4832bb897d5cb4e5f94fa86c32"
    sha256 arm64_sonoma:   "c41455674cf0ff7332fc390420ce86c9e92a876cecfde07856a254706167b162"
    sha256 arm64_ventura:  "4c2c46f7e506de4349b370e2bdd61fef3ada89564446d0eb23969fa3f5ef369c"
    sha256 arm64_monterey: "9412148af6d5be4f3256e07427834522e5c241b5ba7d6b71fefa1112774bf337"
    sha256 arm64_big_sur:  "78689923b7ba4d7d5a4541a93a543effcbc7dcd722d803b47954656c92dfdeca"
    sha256 sonoma:         "459ae4678779b2414a335b5d6080b3636702b139eacf6af354ea2d998a8389c4"
    sha256 ventura:        "eb226e3087a3f58f8bc0dc0eafabfb7625605bc6e023ed45d9386692cb26cc63"
    sha256 monterey:       "edf16c29c279acfdbeecb0202f93ef36852f96060fadf7645b94aa19b0cb054d"
    sha256 big_sur:        "de301856c24aee684544214cb83474fe8237104c9cf214df6777267418b17d9f"
    sha256 catalina:       "9d1ed340349cd7995d1308fc09fc69c3520c96b329ab881dc0d96fce914e029c"
    sha256 arm64_linux:    "04f6e8b1d02ae3b6ab10b9b12083c88d44a8c149f46a9b7ecbfd135324014445"
    sha256 x86_64_linux:   "791d7f7963c86af2f2ef311f739f8faddcbd0448feb0b8213d2b3c2263fc317e"
  end

  patch :DATA

  def install
    ENV.deparallelize

    inreplace "Makefile" do |s|
      # Don't install offensive quotes
      s.change_make_var! "OFFENSIVE", "0"

      # Use our selected compiler
      s.change_make_var! "CC", ENV.cc

      # Change these first two folders to the correct location in /usr/local...
      s.change_make_var! "FORTDIR", "/usr/local/bin"
      s.gsub! "/usr/local/man", "/usr/local/share/man"
      # Now change all /usr/local at once to the prefix
      s.gsub! "/usr/local", prefix

      # macOS only supports POSIX regexes
      s.change_make_var! "REGEXDEFS", "-DHAVE_REGEX_H -DPOSIX_REGEX"
    end

    system "make", "install"
  end

  test do
    system bin/"fortune"
  end
end

__END__
--- a/util/rot.c
+++ b/util/rot.c
@@ -5,6 +5,7 @@
 
 #include <stdio.h>
 #include <ctype.h>
+#include <stdlib.h>
 
 int main(void)
 {
--- a/util/unstr.c
+++ b/util/unstr.c
@@ -96,6 +96,7 @@ static char sccsid[] = "@(#)unstr.c	8.1 (Berkeley) 5/31/93";
 #include	<ctype.h>
 #include	<string.h>
 #include	<unistd.h>
+#include	<stdlib.h>
 
 #ifndef MAXPATHLEN
 #define	MAXPATHLEN	1024
