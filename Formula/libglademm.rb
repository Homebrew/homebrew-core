class Libglademm < Formula
  desc "C++ wrapper around libglade"
  homepage "https://gnome.org"
  url "https://download.gnome.org/sources/libglademm/2.6/libglademm-2.6.7.tar.bz2"
  sha256 "38543c15acf727434341cc08c2b003d24f36abc22380937707fc2c5c687a2bc3"
  license "LGPL-2.1-or-later"
  revision 10

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "213a8e4e74a1c31d52580e1f0438e80bd3a089c9a2fe28f7a5174fb0ecb6e4b9" => :big_sur
    sha256 "53b2b0bb8b46564bce44e054fabbe53968ecc32bca6bb21c1610ec30082c31b8" => :arm64_big_sur
    sha256 "4e32714d9b8b1e87ba17774e43356ebdd29c6ae2593f2eed6ec07460927e6c62" => :catalina
    sha256 "7cd380f335e9461dd9a9726f442b1056ea89cda5cb3ef37b2260462cfdcc4936" => :mojave
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "gtkmm"
  depends_on "libglade"

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libglademm.h>

      int main(int argc, char *argv[]) {
        try {
          throw Gnome::Glade::XmlError("this formula should die");
        }
        catch (Gnome::Glade::XmlError &e) {}
        return 0;
      }
    EOS
    ENV.libxml2
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libglademm-2.4").strip.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
