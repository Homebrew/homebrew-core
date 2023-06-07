class Libglademm < Formula
  desc "C++ wrapper around libglade"
  homepage "https://gnome.org"
  url "https://download.gnome.org/sources/libglademm/2.6/libglademm-2.6.7.tar.bz2"
  sha256 "38543c15acf727434341cc08c2b003d24f36abc22380937707fc2c5c687a2bc3"
  license "LGPL-2.1-or-later"
  revision 11

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3712c292d749cfb8a09008c92428e8dbcdcd76ef1882b47538b11af66f9166ea"
    sha256 cellar: :any,                 arm64_monterey: "bfe629fb08bbc12ac147778cf23f23f8f6ce84b7cbd32a9755a89e2ea42b63b9"
    sha256 cellar: :any,                 arm64_big_sur:  "8311ed9bcd9aa094070b749de1cd62d84645b9dfcbe38fee0cb0c0063c64031a"
    sha256 cellar: :any,                 ventura:        "38c330cae7c6c7f5392d264ec434cfb40ef67a297bd09ad9f09351e207d47575"
    sha256 cellar: :any,                 monterey:       "3e78628204bd2fc1714644a5690dfe1f507dc91c9256792605ac21628ad1a0a0"
    sha256 cellar: :any,                 big_sur:        "5fc582a1ef83d407db91fe1bc3a41560dca9fe4d4be84b1e74f8d6ef531f213c"
    sha256 cellar: :any,                 catalina:       "cde424ee8c6e03ca50817c2f705ccb7c921f45bbb25718a464647fd6efca1a0f"
    sha256 cellar: :any,                 mojave:         "46f3a5ce56212f8ca23c4c73fe820ddfa0eb4a4c4ec456cb1c5cd1e020f5af1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8f4617457fab3adb4da5975e67aa9809d3e83882ca899a60139f316129f4757"
  end

  deprecate! date: "2022-09-18", because: :unmaintained

  depends_on "pkg-config" => [:build, :test]
  depends_on "gtkmm"
  depends_on "libglade"

  def install
    ENV.cxx11
    # Fix flat namespace usage
    inreplace "configure", "${wl}-flat_namespace ${wl}-undefined ${wl}suppress", "${wl}-undefined ${wl}dynamic_lookup"

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
