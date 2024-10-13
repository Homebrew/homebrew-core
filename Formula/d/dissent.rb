class Dissent < Formula
  desc "GTK4 Discord client in Go"
  homepage "https://github.com/diamondburned/dissent"
  url "https://github.com/diamondburned/dissent/archive/refs/tags/v0.0.30.tar.gz"
  sha256 "63994e46b01e135c36902b67a8495eef71d4a4b09204c712629edadfc8398dc6"
  license "GPL-3.0-or-later"
  head "https://github.com/diamondburned/dissent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "003766a7f965f3b7e64141b1abc478746a5e1ef02eb49d5861d3cf1e8f84aaad"
    sha256 cellar: :any,                 arm64_sonoma:   "66b6c8504ad7fec5741ef5421a31efef88b289f2e31a32b79552dc0f0fffa1bf"
    sha256 cellar: :any,                 arm64_ventura:  "ef7e8d322538ff9432f5a31e66d506a0ff7d97cf07221f037a31bb6e2a42797a"
    sha256 cellar: :any,                 arm64_monterey: "0cc276875d7ff3bb230918e987d0a0f6d7e459952cba6ac01f5db030dcd0c0be"
    sha256 cellar: :any,                 sonoma:         "64616dbce97d0114b317eece4ab4916bbc6da6f1520a46ac77a1b2a38763eabc"
    sha256 cellar: :any,                 ventura:        "dd4d843b7c9e421238f4de4bb364451877e3837ab0fcfa785982c111048f462c"
    sha256 cellar: :any,                 monterey:       "e1a4fae5f7fb4e9812ec05b61fbcf5b0fc49063d838ced19513e7bc7aad719d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b780afc4f1ef22b68237f034d24126c07970042087a78c4333065225337f83b"
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
