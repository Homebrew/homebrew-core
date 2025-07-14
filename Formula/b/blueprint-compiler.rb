class BlueprintCompiler < Formula
  desc "Markup language and compiler for GTK 4 user interfaces"
  homepage "https://gnome.pages.gitlab.gnome.org/blueprint-compiler/"
  url "https://gitlab.gnome.org/GNOME/blueprint-compiler.git",
      tag:      "v0.18.0",
      revision: "07c9c9df9cd1b6b4454ecba21ee58211e9144a4b"
  license "LGPL-3.0-or-later"
  head "https://gitlab.gnome.org/GNOME/blueprint-compiler.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "046469ad95ca3a3f99e314ec0d0bfc926b4ecc3f1901a05c586b9166db3b564b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "046469ad95ca3a3f99e314ec0d0bfc926b4ecc3f1901a05c586b9166db3b564b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "046469ad95ca3a3f99e314ec0d0bfc926b4ecc3f1901a05c586b9166db3b564b"
    sha256 cellar: :any_skip_relocation, sonoma:        "cef2f0f835f83500bc1668e917d095315b9fb82a669705848d5e9de3eba5b64f"
    sha256 cellar: :any_skip_relocation, ventura:       "cef2f0f835f83500bc1668e917d095315b9fb82a669705848d5e9de3eba5b64f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02cf8b504b6e344146768692bbd18be7a5bc26df926f7dabb09459b147d1d3e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02cf8b504b6e344146768692bbd18be7a5bc26df926f7dabb09459b147d1d3e1"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  depends_on "gtk4"
  depends_on "pygobject3"

  def install
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
