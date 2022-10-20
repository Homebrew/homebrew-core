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
    sha256 cellar: :any, arm64_monterey: "4decf4b455a9a6eae21225c9f68b6931986dd5c1adea46bc4a613a6f64dbe763"
    sha256 cellar: :any, arm64_big_sur:  "21967730569ea51c23bde4abc11506bd129d75f487b7db91d7c3ea0ff5337b4c"
    sha256 cellar: :any, monterey:       "63960f9c0f9681bd01d1b9395c527efc75d5f107bf0b1d32da2e212cefdcc258"
    sha256 cellar: :any, big_sur:        "8d96843caf94b8b6334b90a66bea767cfaafbcd8953de9477d629853db7de86b"
    sha256 cellar: :any, catalina:       "42c2c260885d3a2449570770f3fd5316e6c47938d5c779bb6fc743d6d7a572ed"
    sha256               x86_64_linux:   "7547251e3a416eeb2df444485d64bdc8be59e24c3821751ff32984de7d8fd97d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "libsndfile"
  depends_on "lv2"
  depends_on "serd"
  depends_on "sord"
  depends_on "sratom"

  def python3
    "python3.10"
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
