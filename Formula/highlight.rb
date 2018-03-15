class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.html"
  url "http://www.andre-simon.de/zip/highlight-3.42.tar.bz2"
  sha256 "a582810384a0c1e870dcd2ca157ba4b5120f898ceb2fd370cfed4f86fc87311e"
  head "https://github.com/andre-simon/highlight.git"

  bottle do
    sha256 "f48af027a4deb24db606fdc9a4aa2d3efe5327c85a86204a8c3eb8c77dc3a8d3" => :high_sierra
    sha256 "8dd037e4bda53d86766dd684ab6d57a84d728c243d50435ac5bc7df6f998d51c" => :sierra
    sha256 "1b1977c1f71eaa35962955956e7a440f061f746a66264663d3df1396a5539f42" => :el_capitan
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
