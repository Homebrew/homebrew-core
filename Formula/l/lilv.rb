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
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "130b4e53fd8079fc21e38a76b8e313a63e2812c195066f46bfaddc665dbdb50b"
    sha256 cellar: :any, arm64_monterey: "b5582d65b08f1ba6287b1257e9338e8b4aa54d04d25909630313a04511c3c2f1"
    sha256 cellar: :any, arm64_big_sur:  "a82cc9f0fad3d3200eab9747d3aefa9e74dcbeb8a8fea5af89bb8dcd6ce65e78"
    sha256 cellar: :any, ventura:        "8281ac099bcec8c94bd4c6a55a8398b180854125f4626ef8bdf484a36726d82c"
    sha256 cellar: :any, monterey:       "4eb1cd9188565a4ebcbc2f15e6f2c5a4ccc4e4b86fe6728448e06723cd73fffb"
    sha256 cellar: :any, big_sur:        "0c615040bed3ee0cdc6d7cc99868c62a51e9febfeefa9ffefd26694bd8a3a09d"
    sha256               x86_64_linux:   "2b32ee9b947c597d1ec17d2095121ac09035bd73d3da3f01e414171fec955f85"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "libsndfile"
  depends_on "lv2"
  depends_on "serd"
  depends_on "sord"
  depends_on "sratom"

  def python3
    "python3.11"
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
