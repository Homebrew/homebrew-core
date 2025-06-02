class Dissent < Formula
  desc "GTK4 Discord client in Go"
  homepage "https://github.com/diamondburned/dissent"
  url "https://github.com/diamondburned/dissent/archive/refs/tags/v0.0.34.tar.gz"
  sha256 "54b437cd2ae63c32cf3fa71d4da327c32de949c68911685031c96752d89b2d1a"
  license "GPL-3.0-or-later"
  head "https://github.com/diamondburned/dissent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a582ef1d6ea47394a7b6df4d265e629b6e2d26386c871b0e6724f5950be562f6"
    sha256 cellar: :any,                 arm64_sonoma:  "f79f724350eca02175363cb382661f0cb5381aee973190cdc269c11b5cff1e7c"
    sha256 cellar: :any,                 arm64_ventura: "4e97c313bbf20d57a379d1642a9023f9a94531893fa61b2954c3f4542ea77e51"
    sha256 cellar: :any,                 sonoma:        "f26bc3ae384baa5f76c3caeb13048b93cdd3702ed253c56c3bbad593b7b4e7fc"
    sha256 cellar: :any,                 ventura:       "5159ff05405959dd2c6e70a1cbe5ad062c3258e9cb26143457e02680a112bf7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a17aa8c1d8575302b2da4ba7b6457f325be94d4d6362536b6e7374f12d98f221"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00f1c7ed586d1e26fc81daf2beac7d88287a9f7abdbe496ad602acd601d31afb"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "gtksourceview5"
  depends_on "libadwaita"
  depends_on "libcanberra"
  depends_on "libspelling"
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
