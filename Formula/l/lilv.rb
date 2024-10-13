class Lilv < Formula
  desc "C library to use LV2 plugins"
  homepage "https://drobilla.net/software/lilv.html"
  url "https://download.drobilla.net/lilv-0.24.24.tar.xz"
  sha256 "6bb6be9f88504176d0642f12de809b2b9e2dc55621a68adb8c7edb99aefabb4f"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?lilv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "f4c262eea637d27903706d2eb1ebcebce75123130de7b51da51ff426883551f5"
    sha256 cellar: :any, arm64_sonoma:  "1045abb56144f25a09abc8df96bba71b6d922d7bf5faf00743cb5cb7f4bd8166"
    sha256 cellar: :any, arm64_ventura: "cda3ce542b0d80a69df22f658b7bb6a7dbde951a363beb263eec45f8d0ce8007"
    sha256 cellar: :any, sonoma:        "50242c1f81ae19f619981e340e693b1f73eea8c2725273c0764e97b9b990b9b8"
    sha256 cellar: :any, ventura:       "f8beefdca7ba8d9ca17ad7aa61aff046d5f9e806459fefadb1b5a11081b0f332"
    sha256               x86_64_linux:  "4ef397a92193d1fca05675bedb76a82ef8ec713e0ab176b1023024a1006f4ad7"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "libsndfile"
  depends_on "lv2"
  depends_on "serd"
  depends_on "sord"
  depends_on "sratom"
  depends_on "zix"

  def python3
    "python3.13"
  end

  def install
    # FIXME: Meson tries to install into `prefix/HOMEBREW_PREFIX/lib/pythonX.Y/site-packages`
    #        without setting `python.*libdir`.
    prefix_site_packages = prefix/Language::Python.site_packages(python3)
    system "meson", "setup", "build", "-Dtests=disabled",
                                      "-Dbindings_py=enabled",
                                      "-Dtools=enabled",
                                      "-Dpython.platlibdir=#{prefix_site_packages}",
                                      "-Dpython.purelibdir=#{prefix_site_packages}",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <lilv/lilv.h>

      int main(void) {
        LilvWorld* const world = lilv_world_new();
        lilv_world_free(world);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/lilv-0", "-L#{lib}", "-llilv-0", "-o", "test"
    system "./test"

    system python3, "-c", "import lilv"
  end
end
