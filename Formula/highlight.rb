class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.html"
  url "http://www.andre-simon.de/zip/highlight-3.40.tar.bz2"
  sha256 "3e55fadd3f2a85f25ea995fd0e57e94e2a59fe2e3ccefe6bd896b50acadc38e3"
  head "https://github.com/andre-simon/highlight.git"

  bottle do
    sha256 "5e86c73e6e146037e9192cc4d4027a868cb2b91d12981ea70d368093639b559f" => :high_sierra
    sha256 "1a9515ca7e5b747225cea738e51ba9782d27d6f5b812bd8bee877a441eb8f735" => :sierra
    sha256 "6be531305cad51de06774efa661e36cbcb789c92d700b8615d1f2f365a84c451" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"

  def install
    conf_dir = etc/"highlight/" # highlight needs a final / for conf_dir
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}"
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}", "install"
  end

  test do
    system bin/"highlight", doc/"examples/highlight_pipe.php"
  end
end
