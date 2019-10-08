class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-3.53.tar.bz2"
  sha256 "2d81f552c663bc3b9dee4cd575c2044c26fe9af0e9b771e4579dc47facc7aec9"
  head "https://gitlab.com/saalen/highlight.git"

  bottle do
    sha256 "fdabb5625c870630c9aee3c74708eb7edd796ee00f67444314387856a49a9900" => :catalina
    sha256 "7c2f411a48a4aee3ca2b8cfa02c3cf6ec574815d82b3767bd1c722d5a055bacf" => :mojave
    sha256 "a3dedbf3f369a275ded3e54f1458aa9e13dc7102d935e025e7d80ade891daa82" => :high_sierra
    sha256 "73e3a17e0dda8ef2ac8f409209eec76bd4dae9a0af3dc4dd92f9bc09d6b9f4d0" => :sierra
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
