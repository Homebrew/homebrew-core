class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-3.54.tar.bz2"
  sha256 "8a50a85e94061b53085c6ad8cf110039217dbdd411ab846f9ff934bec7ecd6d0"
  head "https://gitlab.com/saalen/highlight.git"

  bottle do
    sha256 "c02c61dfc4aee5d36e7567fba45f05552bab5e26a99d7b39693149ade95d3c7f" => :catalina
    sha256 "a0f9bcef112645b17cfc3b71379a4d0da12c6e1341a3690fb23f3721002db317" => :mojave
    sha256 "b917103aa86aa45d780a1118e8058daafab9ae749fac1a18cbc8000080056bd7" => :high_sierra
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
