class Goocanvasmm < Formula
  desc "C++ wrappers for goocanvas"
  homepage "https://www.gtkmm.org"
  url "https://download.gnome.org/sources/goocanvasmm/1.90/goocanvasmm-1.90.11.tar.xz"
  sha256 "80ff11873ec0e73d9e38b0eb2ffb1586621f0b804093b990e49fdb546476ed6e"

  depends_on "pkg-config" => :build
  depends_on "glibmm"
  depends_on "gtkmm3"
  depends_on "goocanvas"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<-EOS.undent
      #include <goocanvasmm.h>
      int main(int argc, char **argv) {
        Goocanvas::init();
      }
    EOS
    system ENV.cc, "-std=c++14", *shell_output("pkg-config --cflags --libs goocanvasmm-2.0").split, testpath/"test.cc", "-o", testpath/"test"
    system testpath/"test"
  end
end
