class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-3.60.tar.bz2"
  sha256 "a65cb4bf6e3d9440500ddd5116ce96edd14014c3d44eb77eba533870e4e71d25"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/saalen/highlight.git"

  bottle do
    sha256 "83dffbd090b52dd14631f638d1efeb9af97787edee3845b81d366733580935ff" => :big_sur
    sha256 "e96e79486cab16ec84802064017f5e97d0f2e3e321e82b172299aff78dd4b82d" => :arm64_big_sur
    sha256 "f7e4a91b1e26ff28387c0aa4f581a9d8a8973cca4608b04d02b44876cc734219" => :catalina
    sha256 "9add800d3b6e9fba4b5c1dc223b987a7c600eef0c75511b80102f939cca1a659" => :mojave
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
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
