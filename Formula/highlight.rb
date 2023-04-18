class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-4.5.tar.bz2"
  sha256 "7763f46927616690e3ecc718827458d119414436d4d6462c8997942d0a211172"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/saalen/highlight.git", branch: "master"

  livecheck do
    url "http://www.andre-simon.de/zip/download.php"
    regex(/href=.*?highlight[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "437bb06f3bd2108637dcee32333f9616014d61610851ae33ab2c1679a86b2ded"
    sha256 arm64_monterey: "608dfc48bc4f3f1f30323f45babbd389cabe9f5a89eaca4270b1a532013f32f0"
    sha256 arm64_big_sur:  "e54f22118d455d5912c078fed6ba3ce7ba4caf502e84a7cf64ac7ab44c8f9a6a"
    sha256 ventura:        "85e8c9bd09e0773d69d49baac2c22c49b27e88e5a8da5d9fdacf486eefb0d85a"
    sha256 monterey:       "fe5614f4e2dcb9c876d73f82107358d3ddcb0b1f148eb0ff90cba0bda9fdc109"
    sha256 big_sur:        "7f77bdbc39da5ef20404041bd6990cc188c3c65766f92326d4092ade2341613e"
    sha256 x86_64_linux:   "c01143118acc17b3e0568d63b2f37d44ccb96463d3c1896d208f590b48df7c1b"
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
