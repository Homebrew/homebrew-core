class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-3.54.tar.bz2"
  sha256 "8a50a85e94061b53085c6ad8cf110039217dbdd411ab846f9ff934bec7ecd6d0"
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
