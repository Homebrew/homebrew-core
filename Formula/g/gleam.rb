class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "5a9c6909bff63bda29f8ca3f6bb18e12b9ff5a3004834c3c8fde64799bdfef04"
  license "Apache-2.0"
  head "https://github.com/gleam-lang/gleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "82f9e68c9c3246bdf823ebb4d1409fa4f5613f060523a1a46747c6f67ff2d7a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3be5bf1f9e3c01bde4890b7210e8c60456420e768664152ea05757b0ab265f2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10c4c3d6fe7894d8d30ba5a479c4ff4e1c5a027221884a8c0b7f97d1b4bd43d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7535554ac94df677af4e405a17c3d8a4270b690e5926f0790f47ed810c79e85"
    sha256 cellar: :any_skip_relocation, ventura:        "d976e2f4f6b68aa674d1260f0b78dacf951d0ad5de259fde0e1415b6b6832718"
    sha256 cellar: :any_skip_relocation, monterey:       "2ca552028818e43c948616cde6ff607d224d0ee9b7dfc27acf09a38f56e84724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b58d809794ecd623d7f0983493982d092ccac9f32f30d3123a8d72ed08c179f3"
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
