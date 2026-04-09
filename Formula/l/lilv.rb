class Lilv < Formula
  desc "C library to use LV2 plugins"
  homepage "https://drobilla.net/software/lilv.html"
  url "https://download.drobilla.net/lilv-0.26.4.tar.xz"
  sha256 "1c8b5fcb78718173e67d76e51ad423f5113a9ff68463f2566195ae46396089e3"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?lilv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0fad3cd65d7e13730119a398cb353a27bf3e08bd6ab20013e7d70ac2a6e5a70c"
    sha256 cellar: :any, arm64_sequoia: "056bb5958fd905ff29a008eddad6012ee4893a3a853785cc81056323a32ca879"
    sha256 cellar: :any, arm64_sonoma:  "eb1093c36ce5e5a635aa82c5ad6295ae879ed3d2a3ec1a79396aae6c43d9c564"
    sha256 cellar: :any, sonoma:        "0a0f97402c765b406aaddce617e49c3c6fcc8d81ecaf0164d44a256fb5e1bfbf"
    sha256               arm64_linux:   "425911220771e7aa4b1daf0f129484b129e7701d29587698c3304ed4f60329d1"
    sha256               x86_64_linux:  "f986509920f7bf14d88a0e06483e99d939471804948abc07474a4b8858cb22ee"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "libsndfile"
  depends_on "lv2"
  depends_on "serd"
  depends_on "sord"
  depends_on "sratom"
  depends_on "zix"

  def python3
    "python3.14"
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
