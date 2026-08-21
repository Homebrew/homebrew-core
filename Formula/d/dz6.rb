class Dz6 < Formula
  desc "Fast Vim-inspired TUI hex editor"
  homepage "https://dz6.dev.br"
  url "https://github.com/mentebinaria/dz6/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "be984784453a0964ff87d3987e488e1aa5a95bf7938ecec28fd5a3a670293f00"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff565c7dbad7d90479a7d6e9b87131c8ded227fe976c1be9a85bc985b70c3c1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e0cebf4ba28505cc46c9aff95f53a15324393c0c38e852b85fce01478a727e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8804f0c3ed7b489336611d67340750c04fb985212085dfcf0fa2fc1fb9bc84d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "90d4347b63d2b677a54538d02d66f1a5eb192a59aaa15d7ab71237f358f8979f"
    sha256 cellar: :any,                 arm64_linux:   "c06250af9cb88df2862cb539e1ff344646450c1ee89c806233958eca00f374bc"
    sha256 cellar: :any,                 x86_64_linux:  "47b4e7cce4b7e593e3297da6d2d732879525ef398ef4b661ec9ec73c9dd631b2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dz6 --version")
    output = shell_output("#{bin}/dz6 #{testpath/"missing.bin"} 2>&1", 1)
    assert_match "No such file or directory", output
  end
end
