class Fcgiwrap < Formula
  desc "CGI support for Nginx"
  homepage "https://www.nginx.com/resources/wiki/start/topics/examples/fcgiwrap/"
  url "https://github.com/gnosek/fcgiwrap/archive/1.1.0.tar.gz"
  sha256 "4c7de0db2634c38297d5fcef61ab4a3e21856dd7247d49c33d9b19542bd1c61f"

  bottle do
    cellar :any
    sha256 "c871c0641217165e88fcdde225c8058a62d043083e434fe3b371c0b7d58ea45f" => :mojave
    sha256 "92140b4ed813b4a718ec9ed035b664fe744a6ae860a4b533ed7425b014e25f22" => :high_sierra
    sha256 "ed81f5b0cec39f7138a877cea2a0e397007d3271393805af53739b837537bd0f" => :sierra
    sha256 "c0a70c3cc726788dfac52d8b23c79c1a4ef31a8c7e1418ac335cfe182b94f05d" => :el_capitan
    sha256 "ea03eeafcd71e07c2e608bc974a00cf642b253de24eb7bd587155c89db2fffad" => :yosemite
    sha256 "15a4dc62dba901bdc25f8d898674069b8cad09b3d2c00458900f31c143305a4e" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "fcgi"

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end
end
