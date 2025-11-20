class Lilv < Formula
  desc "C library to use LV2 plugins"
  homepage "https://drobilla.net/software/lilv.html"
  url "https://download.drobilla.net/lilv-0.26.0.tar.xz"
  sha256 "912f9d025a6b5d96244d8dc51e75dbfc6793e39876b53c196dba1662308db7f0"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?lilv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6b38ac68c566e0fe61886a255c91b588312d5abd3b4b1b1615240370f19f4918"
    sha256 cellar: :any, arm64_sequoia: "c3028d575f05bc1641690901237ce93e5294a9743026b56d0f2525d3d895282f"
    sha256 cellar: :any, arm64_sonoma:  "e2a9e1f5e98bfa25e6ea907e60530780ba86abdc1a3460d96c30d2ed95ee4866"
    sha256 cellar: :any, sonoma:        "98438914958e60ea45827634f596361981d1b8fd5a7a061215cb1ab6477776af"
    sha256               arm64_linux:   "30c4f6519618faf46bbd73da8c0ec2cd955a17ec3c99d7d954eb58368cacc1a6"
    sha256               x86_64_linux:  "245c68a0872099dfcc642514b47bd3933596467d8e92124de6f36bdcd1ad80d8"
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
