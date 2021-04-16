class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-4.0.tar.bz2"
  sha256 "f40dcba26e011a2c67df874f4d9b0238c2c6b065163ce8de3d8371b9dfce864d"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/saalen/highlight.git"

  livecheck do
    url "http://www.andre-simon.de/zip/download.php"
    regex(/href=.*?highlight[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "300cc9aaf56190b6114d5dc1a036feb1dbd3958774cdc365c14e9f1d3d90ef00"
    sha256 big_sur:       "48f8f5490454e944faf513e715136bbf7fbbab0e44f9a1611b868efb8bc95557"
    sha256 catalina:      "840c759500f9cc2b201c5c886ff9d12d34be7145d1ebbce3bc753c4fec5a2837"
    sha256 mojave:        "c12e6e363747d0abe0248640a360ace1841cc394bb25e3662944ba71bb4e710d"
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
