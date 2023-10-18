class Lilv < Formula
  desc "C library to use LV2 plugins"
  homepage "https://drobilla.net/software/lilv.html"
  url "https://download.drobilla.net/lilv-0.24.20.tar.xz"
  sha256 "4fb082b9b8b286ea92bbb71bde6b75624cecab6df0cc639ee75a2a096212eebc"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?lilv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_sonoma:   "afdfcbe8becc467d2880e8c4a3b8c76f9ff900cf2775a3f5f2a6e12ec36e754c"
    sha256 cellar: :any, arm64_ventura:  "c8afec29f808416508908e2f079d5fa398d8913be54374be698813241e06f84b"
    sha256 cellar: :any, arm64_monterey: "0c903766bb257183205bf7e696f9ff7a3af61a8a3d4741e43caa3d55df496599"
    sha256 cellar: :any, sonoma:         "a6432efcfa5eff2c6978fd23f4b0530f9154f09e8561c9433c15821e30038e16"
    sha256 cellar: :any, ventura:        "37eb4c8865f980bf499c626e813fe4fa9330c33a51b6383dffd63d6a851aa034"
    sha256 cellar: :any, monterey:       "1f4b3377de4ae483bb9f782a538c3c1d3f0b6acc11fcaf57f29767975daec230"
    sha256               x86_64_linux:   "7ec369c46d0a6088fdcaf03ff49aa3ccfe1f7610765deb701027d91a82cadf1b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "libsndfile"
  depends_on "lv2"
  depends_on "serd"
  depends_on "sord"
  depends_on "sratom"

  def python3
    "python3.12"
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
