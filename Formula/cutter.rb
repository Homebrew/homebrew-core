class Cutter < Formula
  desc "Unit Testing Framework for C and C++"
  homepage "https://cutter.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/cutter/cutter/1.2.6/cutter-1.2.6.tar.gz"
  sha256 "459becce78ec4c568f4f5a5e20c73ea36be283bf955f4a252e8491b634339065"
  head "https://github.com/clear-code/cutter.git"

  bottle do
    sha256 "467273fc313c512fb5de5a24a060feb86a8f5a87339c0402888512569f09c2c1" => :mojave
    sha256 "565dd12a8b27f69e53a556ad02a448bb18648990a481e004920710a439a892c7" => :high_sierra
    sha256 "ac8c646277a7b623f23ed44aba41c75d52c22d26ed7e0f01759baf9026a9e323" => :sierra
    sha256 "10fdffef5ec4b8983db6547225491720d17cfbcdcbd34b9524facd9f48da04b6" => :el_capitan
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-glibtest",
                          "--disable-goffice",
                          "--disable-gstreamer",
                          "--disable-libsoup"
    system "make"
    system "make", "install"
  end

  test do
    touch "1.txt"
    touch "2.txt"
    system bin/"cut-diff", "1.txt", "2.txt"
  end
end
