class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-4.4.tar.bz2"
  sha256 "9682336941db6b081c9be616ee778fc306386ddd2ed87881db87578bfa2a39ba"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/saalen/highlight.git", branch: "master"

  livecheck do
    url "http://www.andre-simon.de/zip/download.php"
    regex(/href=.*?highlight[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "4a52ed8e7a2be08e915bbb10bea1c631fd7f45ebc2946e0cf812d575930ba571"
    sha256 arm64_monterey: "5d7553122ffe8dab375c4b611c6e8b3475dfeb8308b434e873cf68747b6c424f"
    sha256 arm64_big_sur:  "d87ca1044ade41e0d09f094bfbe5f0a7ed70c8d5775cf3202bbc24954efa218b"
    sha256 ventura:        "1154d78336851ac92914807f166735f025307c479696f2c6604ed71cc31d7328"
    sha256 monterey:       "13cd44ad676ff383c8f8f251e702f8fd972ea898b2b4386dbd2630b7a2808bec"
    sha256 big_sur:        "e73ca9297594376829910577f0fd8ae80166c83c346b0a7bbfa42d64deff7bef"
    sha256 catalina:       "0375a4be9e50c1438074d258fe0c784d7369ca097aea39a52c02068dc298b8ff"
    sha256 x86_64_linux:   "7eaeb10c0bfffbe76e88c83df829ff7c852106a798c741a887f2a03207c13754"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  fails_with gcc: "5" # needs C++17

  def install
    conf_dir = etc/"highlight/" # highlight needs a final / for conf_dir
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}"
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}", "install"
  end

  test do
    system bin/"highlight", doc/"extras/highlight_pipe.php"
  end
end
