class Mdp < Formula
  desc "Command-line based markdown presentation tool"
  homepage "https://github.com/visit1985/mdp"
  url "https://github.com/visit1985/mdp/archive/refs/tags/1.0.19.tar.gz"
  sha256 "4043838ff3048a5234ea6e24ab42301ab78ff3f51ed6ba19c0c4711414f6a74a"
  license "GPL-3.0-or-later"
  head "https://github.com/visit1985/mdp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bc7c67d21f0c09748e11cb3605c17dc4d90dbefbac96075293945513478a191a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fe14956416a82435ae9a5df4897197681db4c3ce3b9ab0a8da04e83202a84055"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d29ea67fa292b84e75c45e001fa8a13cfc96ed766cc77a913f654dbbd1cfe6e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "a09b8a3b168af749ddae205d846ed0c079cfc0d83457e9de1aa8aa39b8d8fcff"
    sha256 cellar: :any,                 arm64_linux:       "adaba2512c59a1bc4bc461716f73cc5aec02747402c0773b02a510886fdf6f05"
    sha256 cellar: :any,                 x86_64_linux:      "3e26cfaaeb34246c1a34408f00ec951c76d3c5356da47a029bd6e5e920b9f16c"
  end

  uses_from_macos "ncurses"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "sample.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdp -v")
  end
end
