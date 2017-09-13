class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.html"
  url "http://www.andre-simon.de/zip/highlight-3.39.tar.bz2"
  sha256 "44f2cef6b5c0b89b5c0d76cf39ce4c2944eeff6b9c23ba27d1d153ac93d10f7d"
  head "https://github.com/andre-simon/highlight.git"

  bottle do
    sha256 "491a19238869bb999ddc86b5a8e5de4bb26202b4c1859f33214a5a1a43dd70d3" => :sierra
    sha256 "00b65b68f59b950497d7b76d41b0861b0686f1c840cc3577b7ad833c85074cb9" => :el_capitan
    sha256 "6b6b82ef51eef60ba9c4e102e2f97b649e1a8734a782eb891547a713b248f70f" => :yosemite
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
