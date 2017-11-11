class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://github.com/newsboat/newsboat/archive/r2.10.1.tar.gz"
  sha256 "82d5e3e2a6dab845aac0bf72580f46c2756375d49214905a627284e5bc32e327"
  head "https://github.com/newsboat/newsboat.git"

  bottle do
    sha256 "9dcbf0d0a026bc0c0667ce52698365f2f172e1222334657a4327c1101304b8ff" => :high_sierra
    sha256 "2094f90b7a64c045e408973420cec64805f4ec517a9397f5850d35d9c013151e" => :sierra
    sha256 "9af1f9da45dcb359481827c3e61e2aef3e21c253b29d436962369b8816be25cc" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "json-c"
  depends_on "libstfl"

  needs :cxx11

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"urls.txt").write "https://github.com/blog/subscribe"
    assert_match /newsboat - Exported Feeds/m, shell_output("LC_ALL=C #{bin}/newsboat -e -u urls.txt")
  end
end
