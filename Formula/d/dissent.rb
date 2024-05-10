class Dissent < Formula
  desc "GTK4 Discord client in Go"
  homepage "https://github.com/diamondburned/dissent"
  url "https://github.com/diamondburned/dissent/archive/refs/tags/v0.0.24.tar.gz"
  sha256 "65537bbc947acfc53fdd7bf0ab98e083fb78af73507b27deec9ba92c1bc783cc"
  license "GPL-3.0-or-later"
  head "https://github.com/diamondburned/dissent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c945bf5d945474d36acdf05c6e9ea0584d5c1021b7c22918f278626f1723302e"
    sha256 cellar: :any,                 arm64_ventura:  "9d18607c8a0ccb1bcc7d5198198266e84863a4d3b36119863e9b4dff9ddbe56e"
    sha256 cellar: :any,                 arm64_monterey: "0035dab703869173a5ea4b61926d978d50eb852259c1ae7b9ca25496d2603e18"
    sha256 cellar: :any,                 sonoma:         "a24f1a11ba24ad181ef7a27ecbb4960b8ad7cf836903e9d89d5aada56481105e"
    sha256 cellar: :any,                 ventura:        "8729e5f9a0d6267f1e15e88737a7226976863ac99d3f3e88566ceb6c0b802290"
    sha256 cellar: :any,                 monterey:       "0b6992a6cb33163bfcd0e71956b8bc00e87051a7e3f870597d4be2d22ae48c85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8d3c45975320f4621985e57b5d891e14ac6be8d823b2c25f06167f47266aaba"
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
