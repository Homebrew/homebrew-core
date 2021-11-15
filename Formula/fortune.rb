class Fortune < Formula
  desc "Infamous electronic fortune-cookie generator"
  homepage "https://www.ibiblio.org/pub/linux/games/amusements/fortune/!INDEX.html"
  url "https://www.ibiblio.org/pub/linux/games/amusements/fortune/fortune-mod-9708.tar.gz"
  mirror "https://src.fedoraproject.org/repo/pkgs/fortune-mod/fortune-mod-9708.tar.gz/81a87a44f9d94b0809dfc2b7b140a379/fortune-mod-9708.tar.gz"
  sha256 "1a98a6fd42ef23c8aec9e4a368afb40b6b0ddfb67b5b383ad82a7b78d8e0602a"

  livecheck do
    url "https://www.ibiblio.org/pub/linux/games/amusements/fortune/"
    regex(/href=.*?fortune-mod[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    rebuild 4
    sha256 arm64_monterey: "9412148af6d5be4f3256e07427834522e5c241b5ba7d6b71fefa1112774bf337"
    sha256 arm64_big_sur:  "78689923b7ba4d7d5a4541a93a543effcbc7dcd722d803b47954656c92dfdeca"
    sha256 monterey:       "edf16c29c279acfdbeecb0202f93ef36852f96060fadf7645b94aa19b0cb054d"
    sha256 big_sur:        "de301856c24aee684544214cb83474fe8237104c9cf214df6777267418b17d9f"
    sha256 catalina:       "9d1ed340349cd7995d1308fc09fc69c3520c96b329ab881dc0d96fce914e029c"
    sha256 mojave:         "9a7a866859df246c3fe9331cb1b131562359690dbc5bfed6ee4e8f5a4585025e"
    sha256 high_sierra:    "3421fe011b2f27d30ae6e56d880eba8a68cb1249d6c4cd063a04fd61022507be"
    sha256 x86_64_linux:   "791d7f7963c86af2f2ef311f739f8faddcbd0448feb0b8213d2b3c2263fc317e"
  end

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
    system "#{bin}/fortune"
  end
end
