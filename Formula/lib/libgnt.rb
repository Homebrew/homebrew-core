class Libgnt < Formula
  desc "NCurses toolkit for creating text-mode graphical user interfaces"
  homepage "https://keep.imfreedom.org/libgnt/libgnt"
  url "https://keep.imfreedom.org/libgnt/libgnt/archive/v2.14.4.tar.gz"
  sha256 "40840dd69832fdae930461e95d8505dabc8854b98a02c258c8833e0519eabe69"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://keep.imfreedom.org/libgnt/libgnt/tags"
    regex(%r{href=["']?[^"' >]*?/rev/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "83d17065c582bdcf162513a0523c19c44db30b00842cda416a2d335b7abc0eb9"
    sha256 cellar: :any, arm64_sonoma:  "40ab4a1893fe00347a02fb7b4cdf258598e1ae27e1594a1c4dff5461633f1a8a"
    sha256 cellar: :any, arm64_ventura: "c564614df4b284c52854d467589dd9603a3502f38c9a07f11a8c35e778617c8b"
    sha256 cellar: :any, sonoma:        "4f3826fd8c722f84e3c568a74c27d48bc3f6a3a15db15721da56447c3f9d9d15"
    sha256 cellar: :any, ventura:       "567c90442a84e13142d104bd45b65df01359f65aa38b67f52f644d4cd1f5c90f"
    sha256               arm64_linux:   "b0f97890b91d6ca699459d1eca4c92793ea59dbf1e5cb7127f7ed051f9cfdfeb"
    sha256               x86_64_linux:  "23fe502bda696d00cfd7dd0f0f4022c46268337ae7bea8b0470b497d89540240"
  end

  depends_on "gtk-doc" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "ncurses"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    # upstream bug report on this workaround, https://issues.imfreedom.org/issue/LIBGNT-15
    inreplace "meson.build", "ncurses_sys_prefix = '/usr'",
                             "ncurses_sys_prefix = '#{Formula["ncurses"].opt_prefix}'"

    system "meson", "setup", "build", "-Dpython2=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gnt/gnt.h>

      int main() {
          gnt_init();
          gnt_quit();

          return 0;
      }
    C

    flags = [
      "-I#{Formula["glib"].opt_include}/glib-2.0",
      "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
      "-I#{include}",
      "-L#{lib}",
      "-L#{Formula["glib"].opt_lib}",
      "-lgnt",
      "-lglib-2.0",
    ]
    system ENV.cc, "test.c", *flags, "-o", "test"
    system "./test"
  end
end
