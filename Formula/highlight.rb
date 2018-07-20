class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-3.44.tar.bz2"
  sha256 "53a1191f1b21130d9690e4c9a82947af11777d8e9569446b997c5a824e601fa4"
  head "https://gitlab.com/saalen/highlight.git"

  bottle do
    sha256 "0f4e807b8f34844013f250cd2199866eca2a7344dc0928cfc0c4c65b2dba1791" => :high_sierra
    sha256 "01915f2af644d25025efcff0a2d58164fcde94ca08ce0911037f7d1cdb99c4f9" => :sierra
    sha256 "e37f2f9fc6b324f8267ad768475f464e7abd3403bc2dd124e3fda2a15b055e36" => :el_capitan
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
