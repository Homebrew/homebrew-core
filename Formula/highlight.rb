class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-3.56.tar.bz2"
  sha256 "764942e25ebf6b2e07b3efa3bb073e1bb64091d1fd667d6d689091707558fa63"
  head "https://gitlab.com/saalen/highlight.git"

  bottle do
    sha256 "a7f3adf340f793ce34105d4f98fb886560602ac226e4a1e374397f3dbecc2a0f" => :catalina
    sha256 "0a952aee823daa9d57984aaf6ba64eeeda353664c1d494b366ebf4b7d576766b" => :mojave
    sha256 "e56c173c28ae2f1312405fc6c190a200712e2b5a0a0a8c0a7e8578a54004e599" => :high_sierra
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
