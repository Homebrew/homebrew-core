class BlueprintCompiler < Formula
  include Language::Python::Virtualenv

  desc "Markup language and compiler for GTK 4 user interfaces"
  homepage "https://gnome.pages.gitlab.gnome.org/blueprint-compiler/"
  url "https://download.gnome.org/sources/blueprint-compiler/0.22/blueprint-compiler-0.22.2.tar.xz"
  sha256 "231d72efbac931c235ac3e022fe94982095c20d88721d9a8dcf60152f2017e07"
  license "LGPL-3.0-or-later"
  head "https://gitlab.gnome.org/GNOME/blueprint-compiler.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8fd88bad67d09958f8a488b9d7dc6b8c1968aad3ed5a8914f30ba277f53e10ac"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  depends_on "gtk4"
  depends_on "pygobject3"
  depends_on "python@3.14"

  def install
    venv = virtualenv_create(libexec, "python3.14")
    # Make meson use the venv's python so the launcher shebang and module dir target it
    ENV.prepend_path "PATH", venv.root/"bin"

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
