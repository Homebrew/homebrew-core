class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "2463831e404762b0a759db874907ab475474535ac2e976a9f249196e34ece054"
  license "Apache-2.0"
  head "https://github.com/gleam-lang/gleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a69b18a37c19179921487b4e5f6de15102980b44160495da9e91acc99cc0b3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b10affa61dba3521f45c873852c5212a19102b44898fe58c2bdad6f49080ced5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af86a05920143f812dfecc9150a1355367c6a44e9a658c62c8088122407837bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "40854206db13f3d2d4c3dbe7602c862f44fb31d3cb18f31052ca6680034f0dcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d3d30ee233db6fcb9e2b33e8053ca5957e47d3d282cea6e82470310a6dbe471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34675b09b1f3122f0d5f9f987e01975be8b2bd2b7445cb47371a097c7fe2c458"
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
