class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://andre-simon.de/doku/highlight/en/highlight.php"
  url "https://gitlab.com/saalen/highlight/-/archive/v4.20/highlight-v4.20.tar.gz"
  sha256 "8db5a2ed7450909b74022d13a4a4b112d313f086a8acd6d36f5bb9f09c633084"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/saalen/highlight.git", branch: "master"

  livecheck do
    url "http://andre-simon.de/zip/download.php"
    regex(/href=.*?highlight[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "9dfe6f10682db5af13a31c743e3929b675b17102ac26f37382c23059560e0d84"
    sha256 arm64_sequoia: "ad2ae8272f5df19a4f0dde8da515966ef65f268d279b9c00cf0c9e12de1c0028"
    sha256 arm64_sonoma:  "c8eb3c89e7fbd86dd6a0f26015a2db2c80663a49f0f054f0fa9f8049b22478d6"
    sha256 sonoma:        "e59e3b979ec5f300fd8c39dc5f798eccfc71ab1d47cc842de35d3ebcd0bb46b4"
    sha256 arm64_linux:   "e4a11273743f4f6e3a7d50c4d1dec76d79e6ba25843d5a2d198fc5e7acb53ee9"
    sha256 x86_64_linux:  "28e4e544db4d5c7b7c6b81123a48ea3f938f5c503357f59289520238cdcbd84c"
  end

  depends_on "boost" => :build
  depends_on "pkgconf" => :build
  depends_on "lua"

  def install
    conf_dir = etc/"highlight/" # highlight needs a final / for conf_dir
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}"
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}", "install"
  end

  test do
    system bin/"highlight", doc/"extras/highlight_pipe.php"
  end
end
