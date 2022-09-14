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
    sha256 cellar: :any, arm64_monterey: "a287d8768b56d67a8baf71692bad390fa5dbf3ff1b46bb3eb6964bc7d11c6d74"
    sha256 cellar: :any, arm64_big_sur:  "7ed8283500c9b8a7296bad00bf72e03b757d717a63c21025959044d5aa4a801e"
    sha256 cellar: :any, monterey:       "b9f9b51da8cffcc343d98c4538c2a95690312143d522b685fd99b3a43143e2d5"
    sha256 cellar: :any, big_sur:        "ef9d9e2c30a64f1fbb3a94ab6e5e6dc276d8069d714810fece4df37c34ebb195"
    sha256 cellar: :any, catalina:       "a3dfb87bf01262c7a28bf552688a0085548a265495bcfa531cf02450dfca816d"
    sha256               x86_64_linux:   "420d1c89561040a8b9acb3700f304d0bc3f9fd35334f7b95c0958374d274321d"
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
