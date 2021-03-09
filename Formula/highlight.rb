class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-3.62.tar.bz2"
  sha256 "d7d025b94a400f6125d7d8596e1d052a65e0a985944a8a85c86299d6f1890d21"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/saalen/highlight.git"

  livecheck do
    url "http://www.andre-simon.de/zip/download.php"
    regex(/href=.*?highlight[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "d0d24c2d0bba6c0f138144b49f0a1a92ec58d5a2cb435b86ce013ce66afedb22"
    sha256 big_sur:       "08a0614af10fb3eb50aab917c324f774b1950cbc0d54d1d0b9336bb2c2e4cdfd"
    sha256 catalina:      "a9a76900789073a37db131c03c4907eb8f2087bba08ac37fe39dfc4e48fd6224"
    sha256 mojave:        "dc988531e289a5f23ed5d59cee32391110ed3c7269172783c6f040af9ab5655e"
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
