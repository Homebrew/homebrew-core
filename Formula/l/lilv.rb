class Lilv < Formula
  desc "C library to use LV2 plugins"
  homepage "https://drobilla.net/software/lilv.html"
  url "https://download.drobilla.net/lilv-0.24.26.tar.xz"
  sha256 "22feed30bc0f952384a25c2f6f4b04e6d43836408798ed65a8a934c055d5d8ac"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?lilv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "3d7ca1236fe7b85cce89cbe85925978028bf312d872e59be8adbba6db9d4b2e3"
    sha256 cellar: :any, arm64_sonoma:  "9123841283fe4c867f2ba7f393c8b09668ce3cc4d2bffa1ba401c5c6f6f48e0b"
    sha256 cellar: :any, arm64_ventura: "d431fdcb61334aa6cc1c87690d60fb8c7c797323ee1367a76f7dc21d90191897"
    sha256 cellar: :any, sonoma:        "7b52532cfaf18e979cba4759c99b09613da4a5a26dac78961fe2f3f49ce3f240"
    sha256 cellar: :any, ventura:       "60b045f4327237d0bc4913bfd0f5628efb2c19a86a26f939eb65100a0aa2da4c"
    sha256               arm64_linux:   "7ba6affd762fbf6e51a685e9c1eb5e763a820ead40d96f1d3eb9e744378ebed2"
    sha256               x86_64_linux:  "061f4cfac8ca9ea8567fd399f092805e3ec13a29403e36e46345d371d3103447"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
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
    (testpath/"test.c").write <<~C
      #include <lilv/lilv.h>

      int main(void) {
        LilvWorld* const world = lilv_world_new();
        lilv_world_free(world);
      }
    C
    system ENV.cc, "test.c", "-I#{include}/lilv-0", "-L#{lib}", "-llilv-0", "-o", "test"
    system "./test"

    system python3, "-c", "import lilv"
  end
end
