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
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "5defe8a7361e21a452aec3724fde3459e1e25cfa40577faf86167f9a72d828b2"
    sha256 cellar: :any, arm64_tahoe:       "403ddd2d07bd03b70179ad59fadd51dc3845c948bff2d24aab720e5ba659dc69"
    sha256 cellar: :any, arm64_sequoia:     "46cbff610130f72c345a23cf8e24ca6cda1f778fbd676bac1bea80011df9bea0"
    sha256 cellar: :any, arm64_linux:       "ebcdcd63b87f5e8a1cb1dde20ab5adf43bd7b68fdc7feeff378b58f7aa50287e"
    sha256 cellar: :any, x86_64_linux:      "1f9d46d8e7edada8da3440f25f31326ed276240f9eb571ae8834a54571255f66"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.15" => [:build, :test]
  depends_on "libsndfile"
  depends_on "lv2"
  depends_on "serd"
  depends_on "sord"
  depends_on "sratom"
  depends_on "zix"

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
