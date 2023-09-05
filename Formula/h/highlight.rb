class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-4.8.tar.bz2"
  sha256 "5ab252d33884acb5c79b8e9a2510b335f874ba69de85c2c20fdf5dc4086fefc5"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/saalen/highlight.git", branch: "master"

  livecheck do
    url "http://www.andre-simon.de/zip/download.php"
    regex(/href=.*?highlight[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "2c052fd965e60ca30909d6a727d89fec12f4f14be39b6516b91d8500564f1183"
    sha256 arm64_monterey: "8d6372f7f31a156ab558765a5e715dd42c87f56cafe2b07b4a7bd25fb077928f"
    sha256 arm64_big_sur:  "8f9a958ec91120c4df066b7545c08efdeca47fa7525ac476cc0de618154e9362"
    sha256 ventura:        "5749e3a4ad149c28af84cd8603c58af0f639dfc8c66e4b97c7d7abc02806b6fd"
    sha256 monterey:       "6122ba35c1d88e5526a574f7280d06004de7d4eb8da894b96163e1e337f14236"
    sha256 big_sur:        "5232732840dd09e1166ce52dfb6c031a3c3d158166cdbab97528e27f93f89a9f"
    sha256 x86_64_linux:   "1b9a5020482409c9e1ff084267a01a0b6b87904524799142f052494b6fa7a51a"
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
