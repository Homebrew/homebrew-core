class BlueprintCompiler < Formula
  desc "Markup language and compiler for GTK 4 user interfaces"
  homepage "https://gnome.pages.gitlab.gnome.org/blueprint-compiler/"
  url "https://gitlab.gnome.org/GNOME/blueprint-compiler.git",
      tag:      "v0.18.0",
      revision: "07c9c9df9cd1b6b4454ecba21ee58211e9144a4b"
  license "LGPL-3.0-or-later"
  head "https://gitlab.gnome.org/GNOME/blueprint-compiler.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "cce13a7d26edd2be79f5a2de5ed261edf0bab59b19c7600d6e4ed0c1368a1eb6"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  depends_on "gtk4"
  depends_on "pygobject3"

  def install
    # Workaround for python binding location
    files = %w[meson.build docs/meson.build]
    inreplace files, "py.get_install_dir()", "'#{Language::Python.site_packages("python3")}'"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.blp").write <<~BLUEPRINT
      using Gtk 4.0;

      template $MyAppWindow: ApplicationWindow {
        default-width: 600;
        default-height: 300;
        title: _("Hello, Blueprint!");

        [titlebar]
        HeaderBar {}

        Label {
          label: bind template.main_text;
        }
      }
    BLUEPRINT
    output = shell_output("#{bin}/blueprint-compiler compile #{testpath}/test.blp")
    assert_match "Hello, Blueprint!", output
  end
end
