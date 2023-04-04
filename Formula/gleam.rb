class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.28.0.tar.gz"
  sha256 "8fe0395b2f9e22426992666270c8bf0b303e52145d5e176e302a9a9d584ed07c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfe2ab6431829929ddb573e0fc7d3901cbee0f5c699910ad409c7623c47c9d83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c1e41d4b8e52c624f5076b58722b192ccdaa2148c78a5f23e80c28afcfa1da4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b191010da88807fbcda0f279d7a3daef360ada698b3030a980adeab0f52c813"
    sha256 cellar: :any_skip_relocation, ventura:        "85e6c24c1aac69e18447539873e626492c348dbb210b4cd148912d4f993409d3"
    sha256 cellar: :any_skip_relocation, monterey:       "92d2706e44ae611da4bd571d7ce7fcbd0c0fe483714a6e97ace033b489c3097f"
    sha256 cellar: :any_skip_relocation, big_sur:        "994c16b926dafcab16cdb722d3b21406c0131ca731369fcddf7183c30f8040ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b6aecb1f421ceb22332ffa2e351e1c63c5ddc6b505206947c77dad70c5dbcfb"
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
