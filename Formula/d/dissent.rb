class Dissent < Formula
  desc "GTK4 Discord client in Go"
  homepage "https://github.com/diamondburned/dissent"
  url "https://github.com/diamondburned/dissent/archive/refs/tags/v0.0.32.tar.gz"
  sha256 "39bf16313640436c097a066623f51c50b0c2be9d13e1cb5fdceba34ebb1652a4"
  license "GPL-3.0-or-later"
  head "https://github.com/diamondburned/dissent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "206163672d6fdd3fa563a5bd39508bb4c00430cf31c4175efeb8febac29fe339"
    sha256 cellar: :any,                 arm64_sonoma:  "34178ce13dc8c20016b777a0f04520452147f44c9f5280d2db904ab500451654"
    sha256 cellar: :any,                 arm64_ventura: "68dbe15af80a99063f98f2b1c049ac57e0d82df6b8b2e9619f2c88047bdfe4d7"
    sha256 cellar: :any,                 sonoma:        "937c8ac8601dc0c849fde1a53c0f5008f69add938abe2cc45f382292639ac7df"
    sha256 cellar: :any,                 ventura:       "f65b70b8e3b300e54760f4b29e238e3629f2bacd5820816c10ad26bda2e95cc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "faebdd245e47aed01574787a3b84dd275d3974f8aa4867e1d324d78940b1ec84"
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
