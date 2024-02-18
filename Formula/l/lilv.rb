class Lilv < Formula
  desc "C library to use LV2 plugins"
  homepage "https://drobilla.net/software/lilv.html"
  url "https://download.drobilla.net/lilv-0.24.24.tar.xz"
  sha256 "6bb6be9f88504176d0642f12de809b2b9e2dc55621a68adb8c7edb99aefabb4f"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?lilv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "b3e4a931c7922733020f34d6b8b25cd9bd85e3f1d1adb70a475d67a79842e2db"
    sha256 cellar: :any, arm64_ventura:  "665a4b7a3fc791aae11b805098ae65e324b32f1ff3b00821fbc8223b8f684fc0"
    sha256 cellar: :any, arm64_monterey: "6cc370093e1fe66b35ab7e42a6f3265b8641facce33b09becb9bff4259ed1c9e"
    sha256 cellar: :any, sonoma:         "980d3580ee9ad524dbf0a5ace961c08e7070047d3ee5c5549e9aad4494f74939"
    sha256 cellar: :any, ventura:        "b41c1eb6a90af9f924b48b4f7326ef3ac9e9ddae5b3c18f2ab94563d5f04da62"
    sha256 cellar: :any, monterey:       "477f88914c2c32edf0f460f69f5232055315bb5efeae20a3836290e06c3ebfd7"
    sha256               x86_64_linux:   "d37711f96389dbb6e78631ae3a67b6d6e41d672452b523f2aa77eafa6ee39fb6"
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
  depends_on "zix"

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
