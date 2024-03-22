class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "f275da337d3eee331d73c22b38832c44d41ed8f6196d5a7c952c137110374c2d"
  license "Apache-2.0"
  head "https://github.com/gleam-lang/gleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "78203dd0babc9831dfabdaacee562e763c008e3c9559ee86cf88bc4774d995e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a96878a9e72112a1489c9738d9f68e32987907547e3d4e81c2928bc96f217c00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ed68d9526147296dfe2c79b4dab21e0a309da3bf7a407818e08c51c95bcfab8"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8e6b074a26e41f5741ef78f2779729489a7e86dfc4cf7f552f32afc24b65f68"
    sha256 cellar: :any_skip_relocation, ventura:        "025854f468b41d474126e11a36003d5954fab67207f0b90712132edbbe0c4434"
    sha256 cellar: :any_skip_relocation, monterey:       "90edfdb18ade227e6992e0b11980f9813b6c07892ff271462cb1f33730601e83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86fde1daea2d9edbd89d8d88f21afa63fb806ab2b3d3874caa2e028a9679e5ce"
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
    system bin/"gleam", "test"
  end
end
