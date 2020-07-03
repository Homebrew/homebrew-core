class Gsmartcontrol < Formula
  desc "Graphical user interface for smartctl"
  homepage "https://gsmartcontrol.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gsmartcontrol/1.1.3/gsmartcontrol-1.1.3.tar.bz2"
  sha256 "b64f62cffa4430a90b6d06cd52ebadd5bcf39d548df581e67dfb275a673b12a9"
  revision 5

  bottle do
    sha256 "f013a063bc125ddf0eb174d8893edc7eea8433aac4ba910b0ed3a11337171fd4" => :catalina
    sha256 "f07ac44ce8d76f469f2bd02da3476f41151416dacb64569a03cf936d8b50697f" => :mojave
    sha256 "67fa6b9c4b3f203916bb66ca3b5b67c2171cbd2d0fd26886746408e09243577f" => :high_sierra
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
