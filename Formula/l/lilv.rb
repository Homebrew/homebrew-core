class Lilv < Formula
  desc "C library to use LV2 plugins"
  homepage "https://drobilla.net/software/lilv.html"
  url "https://download.drobilla.net/lilv-0.26.2.tar.xz"
  sha256 "9c712f7c44ba8b1fdbf9bbaa793bbf76844be40b361c4322bdaa5c4ed36c6b89"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?lilv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "56363d8bf5ba5cfb4d461485d1ad4e7313306429674b10513f67d8c5e6df2436"
    sha256 cellar: :any, arm64_sequoia: "036a5c15d5ec5aab5452303e260b0fd487ab84832c5ca1ff4ac3af8ec12eb07b"
    sha256 cellar: :any, arm64_sonoma:  "41747dbb854c7846ffe4ad410a14276d27e5d5e73014a7062c0e9e0d37646999"
    sha256 cellar: :any, sonoma:        "4acdf2cca9b174913ada149a86474e0c534a9341952133ead18bbab2de3e624c"
    sha256               arm64_linux:   "6cc08d4864ab5c453a1d4e80cb8fb651f92884fa506b0891729847f5104d20b2"
    sha256               x86_64_linux:  "7b75dabc839c8c57b91f4151e7269fde08fb4df3d869ca9a9a26c3b270b8fbb1"
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
