class Dissent < Formula
  desc "GTK4 Discord client in Go"
  homepage "https://github.com/diamondburned/dissent"
  url "https://github.com/diamondburned/dissent/archive/refs/tags/v0.0.35.tar.gz"
  sha256 "86f3fc10a02fc8a84a0e55a8c8c42e280004a57688c743bbe7df16d433abbe5f"
  license "GPL-3.0-or-later"
  head "https://github.com/diamondburned/dissent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "51b9767ca1f33b9d998547d6a58ff5cd7089b3938d180dbd2597b8e6823ee87a"
    sha256 cellar: :any,                 arm64_sonoma:  "e9a9d39aaa1be713525ab45636c8db47541b0f9742062abb65ee507603d8514c"
    sha256 cellar: :any,                 arm64_ventura: "37b012d5625ba573dc4b6fc6da4a24f69bd635f92d795310c5447e3e8e39f882"
    sha256 cellar: :any,                 sonoma:        "531388f222610633645f06a21ecf2d15e74ea392edd18677f28e3a5331e81cea"
    sha256 cellar: :any,                 ventura:       "e16cee20ec2b290a7e2e8120d3457115bc0e3a0380ceb5250b261115996d51da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9afc314d0837d3618eccbff2155256706340ab9c4cf0c931c21e2e54637d78ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "028ce9f4cf38c66396cec94afa29272c55ef574128917c71b53ed1723b5353b9"
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
