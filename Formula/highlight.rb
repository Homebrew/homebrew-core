class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-4.3.tar.bz2"
  sha256 "7dbc3e90f2b564d459ccae2195fa201e0b4442f6754f2da2634e172b2ac5e813"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/saalen/highlight.git", branch: "master"

  livecheck do
    url "http://www.andre-simon.de/zip/download.php"
    regex(/href=.*?highlight[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "683155a52c1f45950708ee40c559a1f955a9b6e13882e344bac63631271643ce"
    sha256 arm64_big_sur:  "caec099d296e0bab619a8c988ac0332690cf4990aa58daba654601ec0466862d"
    sha256 monterey:       "9bf677672f83fd0bfbc559db494b18c3f5268df87b210e6c20d8c03f128b8f28"
    sha256 big_sur:        "d6262d6a8f698e9a0faf9e9a7a912bb4a458d4cdc8c5b0639e644fc712abfb84"
    sha256 catalina:       "0a9f49b9a5616c83da6b24c4a13a19dbe76d2868e131411f97d68066ceee46bb"
    sha256 x86_64_linux:   "d7282ae3f73455fcb13930471050b6f0b3b817b23f47375d782229eced943ad8"
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
