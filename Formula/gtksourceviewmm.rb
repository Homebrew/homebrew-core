class Gtksourceviewmm < Formula
  desc "C++ bindings for gtksourceview"
  homepage "https://developer.gnome.org/gtksourceviewmm/"
  url "https://download.gnome.org/sources/gtksourceviewmm/2.10/gtksourceviewmm-2.10.3.tar.xz"
  sha256 "0000df1b582d7be2e412020c5d748f21c0e6e5074c6b2ca8529985e70479375b"
  license "LGPL-2.1-or-later"
  revision 11

  livecheck do
    url :stable
    regex(/gtksourceviewmm[._-]v?(2\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "bf108d9937d07f20169bf75ad8a5152dd0e49a1b22f280cb0512d44e71a42656" => :big_sur
    sha256 "2916245ab0c9b6b1fc59b1962cf2c21ed517e8adb686ca2b63395a9a66432499" => :arm64_big_sur
    sha256 "db7588b5e582cd8cebe9360a47119c6ffbd8f67e253e47125f2341d1b7b441b4" => :catalina
    sha256 "72ed8cbfc8f32720633bae6c041d04c7bfec0cae44f3aec08d36834cb648f46e" => :mojave
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "gtkmm"
  depends_on "gtksourceview"

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <gtksourceviewmm.h>

      int main(int argc, char *argv[]) {
        gtksourceview::init();
        return 0;
      }
    EOS
    ENV.libxml2
    command = "#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs gtksourceviewmm-2.0"
    flags = shell_output(command).strip.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
