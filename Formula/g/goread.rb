class Goread < Formula
  desc "RSS/Atom feeds in the terminal"
  homepage "https://github.com/TypicalAM/goread"
  url "https://github.com/TypicalAM/goread/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "9b08cae05593034711c599b6b17605194a11bbfae769b4e7e0076a01ec197c37"
  license "GPL-3.0-or-later"
  head "https://github.com/TypicalAM/goread.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de16aa7632f4d0cefab3cfed64fefb063b207059ea2726840976ffbbb32cb5cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f54a965d898329bdd7071bcb6b5d3d3fa76e21ec181c48209943ad9a4e424ab3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f54a965d898329bdd7071bcb6b5d3d3fa76e21ec181c48209943ad9a4e424ab3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f54a965d898329bdd7071bcb6b5d3d3fa76e21ec181c48209943ad9a4e424ab3"
    sha256 cellar: :any_skip_relocation, sonoma:        "28c65443c15b23ca7042ac03c8ba09deb9117e4c931e5423e4367403d5b36553"
    sha256 cellar: :any_skip_relocation, ventura:       "28c65443c15b23ca7042ac03c8ba09deb9117e4c931e5423e4367403d5b36553"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a7e6beb7a80ca028a56c0e13ae193fa6a29134e38de1efece8126f21f1bd8f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bc61108955a4fc3f22de1900278227627b2f5fc44547a92513a751da780e1a1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/goread --test_colors")
    assert_match "A table of all the colors", output

    assert_match version.to_s, shell_output("#{bin}/goread --version")
  end
end
