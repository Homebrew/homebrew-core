class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-3.59.tar.bz2"
  sha256 "85926ca8e08e69b497fa4a0c93bec595e15c1ca18c4ee494ea3f1c9a78c249a2"
  license "GPL-3.0-or-later"
  revision 1
  head "https://gitlab.com/saalen/highlight.git"

  bottle do
    sha256 "67843a8aa6d820f309ae03678db88cc1c515f84d01a2c3db3003c37190bb3bbe" => :big_sur
    sha256 "6ebc0f20fa97135b27033bf086de0f7847f451587a34e9f7f2f0a72ae8529688" => :catalina
    sha256 "8af8c75e2b1463383d79826a70141017db9eca6f78ec2634069d91a601ce6cb7" => :mojave
    sha256 "e68f5df12c9b8365b04226c424960ed252f01a86c429a93f5589b92833c5e752" => :high_sierra
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
