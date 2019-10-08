class Fortune < Formula
  desc "Infamous electronic fortune-cookie generator"
  homepage "https://www.ibiblio.org/pub/linux/games/amusements/fortune/!INDEX.html"
  url "https://www.ibiblio.org/pub/linux/games/amusements/fortune/fortune-mod-9708.tar.gz"
  mirror "https://src.fedoraproject.org/repo/pkgs/fortune-mod/fortune-mod-9708.tar.gz/81a87a44f9d94b0809dfc2b7b140a379/fortune-mod-9708.tar.gz"
  sha256 "1a98a6fd42ef23c8aec9e4a368afb40b6b0ddfb67b5b383ad82a7b78d8e0602a"

  bottle do
    rebuild 3
    sha256 "bde8e2f3f2e9e65c18b72b647cd8aad7658251592fae03717e7d90f4428464de" => :catalina
    sha256 "f635d0fc0504922ba1bfae451f17b874ea96cffb85dead0913adb9da0669738e" => :mojave
    sha256 "b650a61e6b39e9f12179140e0d2b23c0c606e7f29e64851aac5df4e376d77130" => :high_sierra
    sha256 "c6fe1b893c31bc71b2c24de5bcc0a84fbd5025091d796250a7ef4ff6e406eea7" => :sierra
  end

  def install
    ENV.deparallelize

    inreplace "Makefile" do |s|
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
