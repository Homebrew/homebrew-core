class Dissent < Formula
  desc "GTK4 Discord client in Go"
  homepage "https://github.com/diamondburned/dissent"
  url "https://github.com/diamondburned/dissent/archive/refs/tags/v0.0.37.tar.gz"
  sha256 "b08ae331e5c69759eb7b9511908007fc3e9c7a28208bfa66ffbd84b6f335364a"
  license "GPL-3.0-or-later"
  head "https://github.com/diamondburned/dissent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "97643003bef7a54d768a1f7878b036270d6e1845a7089fd76d99141a9eea56a8"
    sha256 cellar: :any,                 arm64_sequoia: "c910693be03f0bd067d9f4d007b836145221602c286039353719daaad66e58c2"
    sha256 cellar: :any,                 arm64_sonoma:  "2b481aebf10e511c8598309b4d2a0e8fbf6ec099af82d4c2102699976e50bd3d"
    sha256 cellar: :any,                 arm64_ventura: "ed3a59ef647f6a22544b57a23ee1a248ba0b03f49ad55145b9acfa3af1488f3d"
    sha256 cellar: :any,                 sonoma:        "5232410d3f1ec1ea33b66ef3abf77f21eabd684cb95061adcf1e34162abcb54e"
    sha256 cellar: :any,                 ventura:       "5a84a47da950058aee7e17a25a13fc41c21de3105b3ed0a29189a1dbdc8fb22d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2f74a11d7d2d4953f4fdc35d06c4b39ad53ef3d316720f7b33d38273782b44b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "330a993d8dd432857f392c561754222f045c86c52d9d2ae6476fe55c0cb3e081"
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
