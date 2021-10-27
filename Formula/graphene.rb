class Graphene < Formula
  desc "Thin layer of graphic data types"
  homepage "https://ebassi.github.io/graphene/"
  url "https://github.com/ebassi/graphene/releases/download/1.10.6/graphene-1.10.6.tar.xz"
  sha256 "80ae57723e4608e6875626a88aaa6f56dd25df75024bd16e9d77e718c3560b25"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "75db915e9b0cb0c4c567912e1d8cf2e78655f136f672429c0eabe56dbd23e147"
    sha256 cellar: :any,                 arm64_big_sur:  "64f77c528bc4e693aef3a747f76eb2c63a1a25f37e730d46fda139c002271301"
    sha256 cellar: :any,                 monterey:       "02d923cb6c5358ae637c0f455b850b8ad7a2d97f2d8993cba979171013f942c6"
    sha256 cellar: :any,                 big_sur:        "20b41dfc4c7bf01973d14f33129db71d7968509e8dc0761f640e36400ae8127e"
    sha256 cellar: :any,                 catalina:       "9a39689fd7d593fc8d5b86b077d153d863c51b470703e87dfd8cfd1ee157d742"
    sha256 cellar: :any,                 mojave:         "d6e6d695f0b7c04b6b8b0b09a18a9cd39bd25ba0e64d5843fa12c0a56100ea06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6345068270ee59e4b48206f62bed5d258f361aa273f7a20c3847d23daa67b46c"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <graphene-gobject.h>

      int main(int argc, char *argv[]) {
      GType type = graphene_point_get_type();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/graphene-1.0
      -I#{lib}/graphene-1.0/include
      -L#{lib}
      -lgraphene-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
