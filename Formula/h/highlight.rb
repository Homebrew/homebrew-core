class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-4.7.tar.bz2"
  sha256 "61db00b817bf76f22b1a3331af9e33705682f05bc1e63d4a0f5c24ff2e0e82b2"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/saalen/highlight.git", branch: "master"

  livecheck do
    url "http://www.andre-simon.de/zip/download.php"
    regex(/href=.*?highlight[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "32fdebdadb619d016a57183c520ecd65f57ffb5edadbd986b6966f15c7665978"
    sha256 arm64_monterey: "1cbcbceaf54fd56262b593579b69e4c89dca509b0ccb60d60468ace55ff8bf1b"
    sha256 arm64_big_sur:  "42c9332f519eb76897de83847a8cd3b4021171f7bfc2ace998798ec82798ab3c"
    sha256 ventura:        "373e160335c129e2a3d39864aa2cca6d311a455452be8e8dfa48d0786fa9c8ae"
    sha256 monterey:       "c137fa82ea6de62a1968e5d5af64f1c2c90a54a79ac6df359fa7065b88517a2a"
    sha256 big_sur:        "d05bad26ef304fbb2c70ed7b4e00c9cf4cf878dd6a1f1882657e8ea85b34a8c1"
    sha256 x86_64_linux:   "451cd5a18278aee33c7b40029d80d1b811e63a1e23e8de284ec4375e09d53753"
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
