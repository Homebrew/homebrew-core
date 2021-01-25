class Gtksourceviewmm3 < Formula
  desc "C++ bindings for gtksourceview3"
  homepage "https://developer.gnome.org/gtksourceviewmm/"
  url "https://download.gnome.org/sources/gtksourceviewmm/3.18/gtksourceviewmm-3.18.0.tar.xz"
  sha256 "51081ae3d37975dae33d3f6a40621d85cb68f4b36ae3835eec1513482aacfb39"
  license "LGPL-2.1-or-later"
  revision 9

  livecheck do
    url :stable
    regex(/gtksourceviewmm[._-]v?(3\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "8c4f4dccd8d2863584a97ade21f7548043396608735140da1e1486f856a8a32d" => :big_sur
    sha256 "73a527b55ab4b0474b2ff5aa5dd416be5b59e181ad995348b4896c6b9b60dcb9" => :arm64_big_sur
    sha256 "0b7aaa428f4ac5c494ac82dc385d6fe170d33e6f09f88f90bb76d85181449a8f" => :catalina
    sha256 "7e6ea75a77e09751dba728dec6b7d87f74a99400fa2c29ea1246f39f57f907fc" => :mojave
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "gtkmm3"
  depends_on "gtksourceview3"

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <gtksourceviewmm.h>

      int main(int argc, char *argv[]) {
        Gsv::init();
        return 0;
      }
    EOS
    ENV.libxml2
    command = "#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs gtksourceviewmm-3.0"
    flags = shell_output(command).strip.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
