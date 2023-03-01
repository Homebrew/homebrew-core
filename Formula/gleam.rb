class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.27.0.tar.gz"
  sha256 "e62bc5976439a17c4c827fa9a25a84c36d08fff1396bbf916ef5219664c17e81"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b958fd09fe43651caeb1b160ee3aba25e6e7f1bc68c1e49f5649d4dd7a2ea94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51d3f04f192c710aac9e6f0117870a43e7fe8a0ca9a9f7b02f201c5b64644913"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99af9339e8343b0cfc6d903b241776591a95742f0af54c26b9063c7895d483c4"
    sha256 cellar: :any_skip_relocation, ventura:        "a372a508a74fd61fd9f5df124074498018d009694494958f6645433c3b0aa93e"
    sha256 cellar: :any_skip_relocation, monterey:       "11833157884bc3a3c8f0b0eac3fa67fcfb8d688b3ddce2aea9906bf367652f87"
    sha256 cellar: :any_skip_relocation, big_sur:        "af3f7981fc8732e5ffb548214050833f22bd20c56e16ee210c1e0409cb6a1df2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1182c29d6c26dd7946d945bb5f816fc3fb6744a919a51d16a25336e587496524"
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
