class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "dd676c5faff4963d7a26683b164788a09f1261326bcb1c7fc20e001ed3843c30"
  license "Apache-2.0"
  head "https://github.com/gleam-lang/gleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e95f70c97f29f634e0984a65684773602b8101d9f73fa89665dc82d76e7e2b35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3801b860dd3ec742d9ce3dd3795ba74f0b84a738287d6609466eda87df0fc8b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "887b67fd668facc362713d20aa1ee0201fad190924afc231e17d407335443049"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e9271d1e9c4af0ca86a91b6d3bbf421223e29201704c11f6b8d003fcbd247fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4f5b3f2c10e7b3c853e3c8294a3dfd34830d17e158ca0d60d63779f55c313b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dd6f3bea1efe0bb31417e7b321024090a58dc27bd2d2f1bb8f50dc8767c7dcd"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  def install
    system "cargo", "install", *std_cargo_args(path: "gleam-bin")
  end

  test do
    system bin/"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system bin/"gleam", "test"
  end
end
