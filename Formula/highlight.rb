class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-4.6.tar.bz2"
  sha256 "3fa1827ba79c512abc5f14e51964e38fd874d6afa23b6f2f09a21bc73e6486c8"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/saalen/highlight.git", branch: "master"

  livecheck do
    url "http://www.andre-simon.de/zip/download.php"
    regex(/href=.*?highlight[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "c674bef6f6770523a5571aac0f4be1f0b6623a496ccd8d645607d3ac963267a7"
    sha256 arm64_monterey: "7d25534b0964f0b2c3970d320dc2b5d6184a9c909a8deb406b34365efea5f76b"
    sha256 arm64_big_sur:  "eeea0f7a6bc9c2f765532fde50e767f5c053a1cc79c8f7d9fc9b878f9140496c"
    sha256 ventura:        "158fe2b718e50c33408aeab1dc873e5d7df61b49253ae3d30811afb815cb6d32"
    sha256 monterey:       "f981d984ff34a5a582228f2df8698223919d649b105d61920b8b54f405c3d636"
    sha256 big_sur:        "5dbbeb30e8ce4e5b450fc91f6216d5532160c5bee6b60a46d0093b9e4021ec11"
    sha256 x86_64_linux:   "76946e61bcbd5fc94b49b3de2fa20292e15278bed7583480071a6708b6fa3c72"
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
