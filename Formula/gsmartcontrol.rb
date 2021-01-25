class Gsmartcontrol < Formula
  desc "Graphical user interface for smartctl"
  homepage "https://gsmartcontrol.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gsmartcontrol/1.1.3/gsmartcontrol-1.1.3.tar.bz2"
  sha256 "b64f62cffa4430a90b6d06cd52ebadd5bcf39d548df581e67dfb275a673b12a9"
  revision 8

  livecheck do
    url :stable
  end

  bottle do
    sha256 "a7edc375fddc2f1bd0a0ef54579aebb80941b51ce0b16d6dc0e6e174b894376b" => :big_sur
    sha256 "87f1f004a8d37328c3a246bd66a3338ad14247ed38f7c7e75c5f8e274795b610" => :arm64_big_sur
    sha256 "013dc10e96aee3db96ad08f2b460839cd1c2afa7440965b0f64f12dda5dd1728" => :catalina
    sha256 "1fd22b0404a9b3da97aa728c6421340380d271d708c0c15734eadcf82bde6410" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "gtkmm3"
  depends_on "pcre"
  depends_on "smartmontools"

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{sbin}/gsmartcontrol", "--version"
  end
end
