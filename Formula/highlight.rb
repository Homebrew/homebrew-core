class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-3.47.tar.bz2"
  sha256 "cec440d4a5e56d371009c45baeb19caa9040c97b52916b7a29ddd2520e722d76"
  head "https://gitlab.com/saalen/highlight.git"

  bottle do
    sha256 "f40833cf203b6209059636d0b5e3e9c45359f37216364507752f3b6dccd3458e" => :mojave
    sha256 "f7a288847bb0ec68e466c69dc54abf341053d0fd2463c004debb7dce5db5384c" => :high_sierra
    sha256 "0599ac77ccc7e4b35c69fc3c9f83989a02281ea725649a8bc4435e778efcabdb" => :sierra
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
