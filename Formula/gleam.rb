class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.23.0.tar.gz"
  sha256 "d5b159474be38c3e4c54c3b54442c306a1137f8602141e1545d67e9b8f4c22bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9e847959a38ec1e4fae46e60c241432b06449c843dd7428bf450791ecc6b228"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41d07a6a2141d8d020620257e6c25a2f77e3f1bdf6c15f5571701c08ed5431c7"
    sha256 cellar: :any_skip_relocation, monterey:       "a0ad600fe24b6f93bd5f3c06fe153b1c1a55b34f412ccd25864356a33ff10d21"
    sha256 cellar: :any_skip_relocation, big_sur:        "319f730a2571aac66abcc87b744e651ccec205bf7d581f0da3820dc3cccf1f7b"
    sha256 cellar: :any_skip_relocation, catalina:       "43f9453ed923bd60aad3da62f60f83337fcd300f042e5e09e91de5af47bdf9fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a337b07dff81aa878e02a7767d2c871981c3ea7f294a401d7aaae1e47bf562b"
  end

  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "compiler-cli")
  end

  test do
    Dir.chdir testpath
    system bin/"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system "gleam", "test"
  end
end
