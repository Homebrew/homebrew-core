class AppstreamGlib < Formula
  desc "Helper library for reading and writing AppStream metadata"
  homepage "https://github.com/hughsie/appstream-glib"
  url "https://github.com/hughsie/appstream-glib/archive/refs/tags/appstream_glib_0_8_4.tar.gz"
  sha256 "19798c8fbd2734554848817e52ef351d21253b1df9fff288b7cf91c10618415d"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^appstream_glib[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5940ef5586450154dfd2eee03d673fce232374fff4f7f5fd6d44a87d1f7343d5"
    sha256 cellar: :any, arm64_sequoia: "e571c3858322af4ee835adb1bf539d44210b647adc9bd67f998501cc9da377a7"
    sha256 cellar: :any, arm64_sonoma:  "ac0e836cee5fbd1a0d0303be6184ac32d7a7969ccbd1b377a941ee9a227c7b1c"
    sha256 cellar: :any, sonoma:        "efef49ed2c2effbfb95714a002f0e15a9c3fe93fe0ba97e96ca59409f289cb98"
    sha256               arm64_linux:   "894398250155525e2a6ca37a0b4702d82592d9e20701738f79cdce239e5192c5"
    sha256               x86_64_linux:  "6373eab42c9461038aa174ac4b6f52914d08a6f602e405cdecd640c7227521e3"
  end

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "json-glib"
  depends_on "libarchive"

  uses_from_macos "gperf" => :build
  uses_from_macos "curl"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "util-linux"
  end

  def install
    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "meson", "setup", "build", "-Dbuilder=false", "-Drpm=false", "-Ddep11=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <appstream-glib.h>

      int main(int argc, char *argv[]) {
        AsScreenshot *screen_shot = as_screenshot_new();
        g_assert_nonnull(screen_shot);
        return 0;
      }
    C

    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("libarchive")/"pkgconfig"
    flags = shell_output("pkgconf --cflags --libs appstream-glib").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
    system bin/"appstream-util", "--help"
  end
end
