class Lilv < Formula
  desc "C library to use LV2 plugins"
  homepage "https://drobilla.net/software/lilv.html"
  url "https://download.drobilla.net/lilv-0.28.0.tar.xz"
  sha256 "8dcb70adb5cf072335115a6b091f4113710bdc73abaadaa3f9e9c1e55957b149"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?lilv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "eef8f28761d4dbfdfee42f86aab7e9d439dd0bce146314dfba3a344f4d0851ce"
    sha256 cellar: :any, arm64_sequoia: "d5902978fdfcfd937d5168e6dc4ab6b4711a253827fbc1dad8e59914397c14f1"
    sha256 cellar: :any, arm64_sonoma:  "ef5803ca8b94026ecb23a90feb73a8edea6b0a6fd29a34b5e765bfc8c8310e45"
    sha256 cellar: :any, sonoma:        "1e79fdd12fdeba6c09c2f61682d10a7b7be0c2a239b62d24c20cb1c5d207261a"
    sha256               arm64_linux:   "acc618ed645603b0dca6246c853ddc40fcf089205fc916e5f5b5810d602928a7"
    sha256               x86_64_linux:  "0e88b42928fd1622e36cfbeb5b5f80ac90597cd6e4b5acc919604f6976cfae40"
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
