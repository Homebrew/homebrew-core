class Dissent < Formula
  desc "GTK4 Discord client in Go"
  homepage "https://github.com/diamondburned/dissent"
  url "https://github.com/diamondburned/dissent/archive/refs/tags/v0.0.27.tar.gz"
  sha256 "c2680b6722be898a7293ef67b99da611b15e104eadc0f2e412a92b7ad3db12c3"
  license "GPL-3.0-or-later"
  head "https://github.com/diamondburned/dissent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4ebbf1e0e44dcbacefd93dd41f213f6f1f5ed4e01c229d0f921903749d44bd40"
    sha256 cellar: :any,                 arm64_ventura:  "97ceb1036491e64f6da6ec6c2fc798b292fa738c3e08dd4b5b2928ecf85db2db"
    sha256 cellar: :any,                 arm64_monterey: "6642ce09c7cb01df966ed833190f98087d963a80c6cfa34ce0abeb0b8dd225f8"
    sha256 cellar: :any,                 sonoma:         "0687a92e3fa95d47751c964c9cdc99d6108eaff60d3b0e2718b0bce78547a32e"
    sha256 cellar: :any,                 ventura:        "eeccf2e1111d86e56257a7e088e9555253e22c78d6eb00c59dca5ea930a51132"
    sha256 cellar: :any,                 monterey:       "716076cb7b696b25b5340980fa607b0374738423a6fd359f02b7e4574b192d70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15e624f1de8e498dc56bf270ae0a72ce362679581286d857b55f63deb1f2130a"
  end

  depends_on "go" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "libadwaita"
  depends_on "libcanberra"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # dissent is a GUI application
    system bin/"dissent", "--help"
  end
end
