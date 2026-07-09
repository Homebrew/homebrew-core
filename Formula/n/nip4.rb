class Nip4 < Formula
  desc "Image processing spreadsheet"
  homepage "https://github.com/libvips/nip4"
  url "https://github.com/libvips/nip4/releases/download/v9.1.5/nip4-9.1.5.tar.xz"
  sha256 "ceea7a00f9e8182195c3b4a62416145dbc303f44f62a09bfce0690fd6fbf1ecc"
  license "GPL-2.0-or-later"
  head "https://github.com/libvips/nip4.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "48b2537486791b695b2db3dfc6f9a6d21d8d5e6e09e810e9a2b78e270b541de5"
    sha256 cellar: :any, arm64_sequoia: "bf86540a66ee54a7c3d9b23552c791d1e3269a70c6ca39be8f7815a7ef576e09"
    sha256 cellar: :any, arm64_sonoma:  "f6ce13eb35019676e1265847c0384d02664d1ee56d0225699d50462353502a31"
    sha256 cellar: :any, sonoma:        "5cd0d425c79b1415224d610af7a64bcd1885149b42dde2a5ddfebc8b6dec135e"
    sha256               arm64_linux:   "c62672a777024439d177d1605d99894b8fe9198172bea4294138d008bd445ba5"
    sha256               x86_64_linux:  "cc9704cd5f033d40423e1bd251ab6b232eb7437b3f54a2f7c085368a1833e8b1"
  end

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "graphene"
  depends_on "gsl"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "libxml2"
  depends_on "pango"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Avoid running `meson` post-install script
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  post_install_steps do
    compile_gsettings_schemas
    gtk_update_icon_cache
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/nip4 --version")

    # nip4 is a GUI application
    spawn bin/"nip4" do |_r, _w, pid|
      sleep 5
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
