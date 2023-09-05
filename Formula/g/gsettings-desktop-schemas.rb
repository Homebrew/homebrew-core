class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/44/gsettings-desktop-schemas-44.0.tar.xz"
  sha256 "eb2de45cad905994849e642a623adeb75d41b21b0626d40d2a07b8ea281fec0e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34378cb4fbe92b9bbfdad8b568a851a604701e6de75a9e844183253103a97dd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34378cb4fbe92b9bbfdad8b568a851a604701e6de75a9e844183253103a97dd8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34378cb4fbe92b9bbfdad8b568a851a604701e6de75a9e844183253103a97dd8"
    sha256 cellar: :any_skip_relocation, ventura:        "34378cb4fbe92b9bbfdad8b568a851a604701e6de75a9e844183253103a97dd8"
    sha256 cellar: :any_skip_relocation, monterey:       "34378cb4fbe92b9bbfdad8b568a851a604701e6de75a9e844183253103a97dd8"
    sha256 cellar: :any_skip_relocation, big_sur:        "34378cb4fbe92b9bbfdad8b568a851a604701e6de75a9e844183253103a97dd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2523f822bacf9adf85f948fd40244e1685f3fd795522278a92b0f48e85df5b00"
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
