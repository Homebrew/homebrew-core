class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/43/gsettings-desktop-schemas-43.0.tar.xz"
  sha256 "5d5568282ab38b95759d425401f7476e56f8cbf2629885587439f43bd0b84bbe"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af182c58a3eb7b6cdebdcbd1fb34b52450ae758101656d4b555c3f5bc7bffb8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af182c58a3eb7b6cdebdcbd1fb34b52450ae758101656d4b555c3f5bc7bffb8f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af182c58a3eb7b6cdebdcbd1fb34b52450ae758101656d4b555c3f5bc7bffb8f"
    sha256 cellar: :any_skip_relocation, ventura:        "af182c58a3eb7b6cdebdcbd1fb34b52450ae758101656d4b555c3f5bc7bffb8f"
    sha256 cellar: :any_skip_relocation, monterey:       "af182c58a3eb7b6cdebdcbd1fb34b52450ae758101656d4b555c3f5bc7bffb8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "af182c58a3eb7b6cdebdcbd1fb34b52450ae758101656d4b555c3f5bc7bffb8f"
    sha256 cellar: :any_skip_relocation, catalina:       "af182c58a3eb7b6cdebdcbd1fb34b52450ae758101656d4b555c3f5bc7bffb8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43a118bc1e52f9b8b21db50f93783c08cbc99fc51cb4d14a9a3bfd9e87c3697b"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "glib"

  uses_from_macos "expat"

  def install
    ENV["DESTDIR"] = "/"

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
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
