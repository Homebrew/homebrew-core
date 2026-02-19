class BlueprintCompiler < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Markup language and compiler for GTK 4 user interfaces"
  homepage "https://gnome.pages.gitlab.gnome.org/blueprint-compiler/"
  url "https://gitlab.gnome.org/GNOME/blueprint-compiler/-/archive/0.19.0/blueprint-compiler-0.19.0.tar.gz"
  sha256 "f5aaf95d8a0ba4c8ad104465dd3df3eeb2e72b67785d969d7fd8bc7cf4127ee9"
  license "LGPL-3.0-or-later"
  head "https://gitlab.gnome.org/GNOME/blueprint-compiler.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b78efc382e4cc768ec177a1c5495d31ca74063b9be63f2b69f3b507ea8a1d183"
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
