class ChooseRust < Formula
  desc "Human-friendly and fast alternative to cut and (sometimes) awk"
  homepage "https://github.com/theryangeary/choose"
  url "https://github.com/theryangeary/choose/archive/v1.3.3.tar.gz"
  sha256 "336225a05d98e536f79969c2d1727c8371df3d289e4aebe15a1a476db0f84df2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4fd4069940db442a74a4eeebb6b4de80e5257940b8a1ee0558c62a315d43d644"
    sha256 cellar: :any_skip_relocation, big_sur:       "b9d899b01f98077348581963c4580663f02548a5feef617fe5cec5c12be20d3d"
    sha256 cellar: :any_skip_relocation, catalina:      "ece9bf8ad73141a5577d68a896efc36ae6c4761359e05136a556a763e273cd26"
    sha256 cellar: :any_skip_relocation, mojave:        "fa56904f7112494b4956719fb17918dcf050352a444655c007584b9d21c3f970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4eaa916ead46d0b11839038074a62e99fa3ce4710ba64e50f798ad28278f80c5"
  end

  depends_on "rust" => :build

  conflicts_with "choose", because: "both install a `choose` binary"
  conflicts_with "choose-gui", because: "both install a `choose` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input = "foo,  foobar,bar, baz"
    assert_equal "foobar bar", pipe_output("#{bin}/choose -f ',\\s*' 1..=2", input).strip
  end
end
