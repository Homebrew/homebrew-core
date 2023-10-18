class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/45/gsettings-desktop-schemas-45.0.tar.xz"
  sha256 "365c8d04daf79b38c8b3dc9626349a024f9e4befdd31fede74b42f7a9fbe0ae2"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b07d5867f7317b046208fdacf52f9c780a9bbd6264bab81dba80268b13dbe76"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b07d5867f7317b046208fdacf52f9c780a9bbd6264bab81dba80268b13dbe76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b07d5867f7317b046208fdacf52f9c780a9bbd6264bab81dba80268b13dbe76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b07d5867f7317b046208fdacf52f9c780a9bbd6264bab81dba80268b13dbe76"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b07d5867f7317b046208fdacf52f9c780a9bbd6264bab81dba80268b13dbe76"
    sha256 cellar: :any_skip_relocation, ventura:        "9b07d5867f7317b046208fdacf52f9c780a9bbd6264bab81dba80268b13dbe76"
    sha256 cellar: :any_skip_relocation, monterey:       "9b07d5867f7317b046208fdacf52f9c780a9bbd6264bab81dba80268b13dbe76"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b07d5867f7317b046208fdacf52f9c780a9bbd6264bab81dba80268b13dbe76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4069d503079788203fdf238665cf49a9aed09f5f933987fb4a126b303f35aa92"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "glib"

  uses_from_macos "expat"

  def install
    ENV["DESTDIR"] = "/"
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    # manual schema compile step
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gdesktop-enums.h>

      int main(int argc, char *argv[]) {
        return 0;
      }
    EOS
    system ENV.cc, "-I#{HOMEBREW_PREFIX}/include/gsettings-desktop-schemas", "test.c", "-o", "test"
    system "./test"
  end
end
