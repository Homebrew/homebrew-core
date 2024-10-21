class Dissent < Formula
  desc "GTK4 Discord client in Go"
  homepage "https://github.com/diamondburned/dissent"
  url "https://github.com/diamondburned/dissent/archive/refs/tags/v0.0.30.tar.gz"
  sha256 "63994e46b01e135c36902b67a8495eef71d4a4b09204c712629edadfc8398dc6"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/diamondburned/dissent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f2448419bd81de8a1f256651ab3328c1cd75f3da232fe057b9f56f611abac5ea"
    sha256 cellar: :any,                 arm64_sonoma:  "ef3779084e55a473b8c56c6415908ac61a9f2d447fa1d1c0da723326eecbcd7b"
    sha256 cellar: :any,                 arm64_ventura: "a518a0006ad3eefc5f4db860f3ca1d4225efdf8960c4f41a7fddabf6cbb1c2d7"
    sha256 cellar: :any,                 sonoma:        "d55fd2d47ff74a860f02ac9ccb7bfd82d917cf3a7399273487fe08061c90f690"
    sha256 cellar: :any,                 ventura:       "d216f4360abd678c659f65d36afff0ed4b3dc515994c0e88e60063506ab5af29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c96d63371bdfe8c13999e181d862d8cc3ac2efb6aaa91e230f757f2cc141dd7f"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "gtksourceview5"
  depends_on "libadwaita"
  depends_on "libcanberra"
  depends_on "libspelling@0.2"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # Fails in Linux CI with "Failed to open display"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # dissent is a GUI application
    system bin/"dissent", "--help"
  end
end
