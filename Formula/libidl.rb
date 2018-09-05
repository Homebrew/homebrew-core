class Libidl < Formula
  desc "Library for creating CORBA IDL files"
  homepage "https://ftp.acc.umu.se/pub/gnome/sources/libIDL/0.8/"
  url "https://download.gnome.org/sources/libIDL/0.8/libIDL-0.8.14.tar.bz2"
  sha256 "c5d24d8c096546353fbc7cedf208392d5a02afe9d56ebcc1cccb258d7c4d2220"

  bottle do
    cellar :any
    rebuild 1
    sha256 "dbfb979d79a6061a62af7f763e669bea983675f98508fe0fce915d4db038b8d7" => :mojave
    sha256 "3d80aba8c6f6cc762bf20abbcdc5098d39d9cc5ecc9a31f1e08b96c35deb1004" => :high_sierra
    sha256 "d8c0e559183f9cfb1ac579acb95db74c73c4f276ac791eb4ffcb65db8e47c0ca" => :sierra
    sha256 "0c81487e7c93733097a62e6c693943fda8b13ce03ff6a6972a320c711d561e39" => :el_capitan
    sha256 "356ad466ab477116e8f030ef75b70bc46321f68ec1f077f9b06dca3bb076e499" => :yosemite
    sha256 "dffe56b6e1076ac49a43ff662517b974f97e47707906362629176cfdc09b6f91" => :mavericks
    sha256 "7aee2ea7f3760687e9acd4a35c393e240f8f59e94a36c2a31812d15a41cfcac8" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
