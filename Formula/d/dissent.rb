class Dissent < Formula
  desc "GTK4 Discord client in Go"
  homepage "https://github.com/diamondburned/dissent"
  url "https://github.com/diamondburned/dissent/archive/refs/tags/v0.0.37.tar.gz"
  sha256 "b08ae331e5c69759eb7b9511908007fc3e9c7a28208bfa66ffbd84b6f335364a"
  license "GPL-3.0-or-later"
  head "https://github.com/diamondburned/dissent.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "dd1e49a1cba57126c5863d4a2b677b02fd03fdbaf8a1ce6f81474007b9394661"
    sha256 cellar: :any,                 arm64_sequoia: "b45fd55dfd1e9cd6191fb59cc7cac06c310e90414a44033c916c84fb572da839"
    sha256 cellar: :any,                 arm64_sonoma:  "9604a42062cae3551df4c41f8c47a79f7d743fd8fe42c870655240652d79c074"
    sha256 cellar: :any,                 sonoma:        "ea9319c548bdd84c5a00e110f352299d4c3f586fc9a176005e71dd5fdd18ad07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09d43aa6bfef20752ac31e2b33ad1737a2e40ee0d57bf3ee214833302e2ad81a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7cb6a3cebf7c5fcebeed8c7ee8180e59dc465c4e9c4c1595b40de885392caaa"
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

  on_linux do
    depends_on "xorg-server" => :test
  end

  def install
    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arm64?
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # dissent is a GUI application
    cmd = "#{bin}/dissent --help"
    cmd = "#{Formula["xorg-server"].bin}/xvfb-run #{cmd}" if OS.linux? && ENV.exclude?("DISPLAY")
    assert_match "Show all help options", shell_output(cmd)
  end
end
