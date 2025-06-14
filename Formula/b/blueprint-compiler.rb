class BlueprintCompiler < Formula
  desc "Markup language and compiler for GTK 4 user interfaces"
  homepage "https://gnome.pages.gitlab.gnome.org/blueprint-compiler/"
  url "https://gitlab.gnome.org/GNOME/blueprint-compiler.git",
      tag:      "v0.16.0",
      revision: "04ef0944db56ab01307a29aaa7303df6067cb3c0"
  license "LGPL-3.0-or-later"
  head "https://gitlab.gnome.org/GNOME/blueprint-compiler.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "934e915f724789737e2aff49d9607966366342257941e1f44ee5d03c358d331a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "934e915f724789737e2aff49d9607966366342257941e1f44ee5d03c358d331a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "934e915f724789737e2aff49d9607966366342257941e1f44ee5d03c358d331a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bea1eb3d4da51a7e9e8ee222b7c8dec211a3cbffc00932d1e26ffc6645d499e"
    sha256 cellar: :any_skip_relocation, ventura:       "6bea1eb3d4da51a7e9e8ee222b7c8dec211a3cbffc00932d1e26ffc6645d499e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43d7f2741a5fa0dd074c78f6eac27decea1c8105ed1f9c53892ca7f3d2e7c10e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd8299938011b24bc84df5f61ec14fea43ccd470ada9f70e92a14e195a138a8b"
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
