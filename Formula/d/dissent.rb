class Dissent < Formula
  desc "GTK4 Discord client in Go"
  homepage "https://github.com/diamondburned/dissent"
  url "https://github.com/diamondburned/dissent/archive/refs/tags/v0.0.22.tar.gz"
  sha256 "756f7bf983e98e035655a66388a3409f02939c972d6bd024a5177a389cbde5c4"
  license "GPL-3.0-or-later"
  head "https://github.com/diamondburned/dissent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "091c5b97bce32dc74e31d8ac46ebfca28778528b38cd6f88435d6c6aa05193ff"
    sha256 cellar: :any,                 arm64_ventura:  "d818161844d7f7efc538716ded781b0981bd7597a2ee6f6041e3f0c46dcce6b2"
    sha256 cellar: :any,                 arm64_monterey: "a94ade0b04f24afd560e41f93f5f978d2ed9d27b01367f50ab179516d3a445ea"
    sha256 cellar: :any,                 sonoma:         "d3c0d7f6f7769096015136d28cb6ed9b3fc92611750b273fb5b145ac42c7dcb6"
    sha256 cellar: :any,                 ventura:        "eb16e1a3e2fbf51f750826919580c0c87fec9b21382fb1def3431aad618738df"
    sha256 cellar: :any,                 monterey:       "17042c8cfce4fe4743a490d385f0bb09e81e451d78c4854e86736ef7704123bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e2917f35b582c2bf534adbc8eceb93efdbf30efe049166b2b3b39ce4402192b"
  end

  depends_on "go" => :build
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "libadwaita"
  depends_on "libcanberra"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # dissent is a GUI application
    system bin/"dissent", "--help"
  end
end
