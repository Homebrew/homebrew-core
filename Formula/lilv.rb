class Lilv < Formula
  desc "C library to use LV2 plugins"
  homepage "https://drobilla.net/software/lilv.html"
  url "https://download.drobilla.net/lilv-0.24.18.tar.xz"
  sha256 "f65814ae60be54d65f1671dff7538aeddcda3610cb6e46ec96de47f84ab0f3b8"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?lilv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "35493821e5b6a936cffa6c60e3ff699d5cc0e7595e70efbc3758348e90a79566"
    sha256 cellar: :any, arm64_big_sur:  "2c6d68f67038aca35ff62010fde5607bad51cf2911ba73aedec52bda648099ac"
    sha256 cellar: :any, monterey:       "630b9d5c643eb44ee2861e570e505e21ae87f78af8a0298b45fcdbbd2068d5d1"
    sha256 cellar: :any, big_sur:        "c0ddb2bdec0549af2f9b6b9d7b44c311923ab3b30190716df82946096f1396b1"
    sha256 cellar: :any, catalina:       "a5ea5735f1a830429af196b658a3eacd97de49ec937ad7f2fc1f116248e41a6e"
    sha256               x86_64_linux:   "e72a37206417ea6582aae51658694336caf014d06b9503bb6beb752abbb1ecde"
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
