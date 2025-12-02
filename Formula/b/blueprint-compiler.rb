class BlueprintCompiler < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Markup language and compiler for GTK 4 user interfaces"
  homepage "https://gnome.pages.gitlab.gnome.org/blueprint-compiler/"
  url "https://gitlab.gnome.org/GNOME/blueprint-compiler/-/archive/0.18.0/blueprint-compiler-0.18.0.tar.gz"
  sha256 "51aa472ecd7bd4b32b8baa7ae6768b19810793d4a2a1aba39c5b31b0170cb258"
  license "LGPL-3.0-or-later"
  revision 1
  head "https://gitlab.gnome.org/GNOME/blueprint-compiler.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "d935e3b6be2f9ca0baba92580a768de9e3bdc89f3d55e24113e39336456eb414"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  depends_on "gtk4"
  depends_on "pygobject3"
  depends_on "python@3.14"

  def install
    python3 = "python3.14"
    venv = virtualenv_create(libexec, python3)

    system "meson", "setup", "build", "-Dpython.platlibdir=#{venv.site_packages}",
                                      "-Dpython.purelibdir=#{venv.site_packages}",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    rewrite_shebang python_shebang_rewrite_info(venv.root/"bin/python"), *bin.children
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
