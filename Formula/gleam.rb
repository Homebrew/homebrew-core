class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.18.2.tar.gz"
  sha256 "42e1592312660ab96ce7167e222f8eea00e8c38498cf6d30300355b69af270bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce6bb0bb6f2fad62bd158438a6ddb60420c49e5b9ddcfa54e3da12b03d8db842"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4009721f9a3088ca728e13c87850b5464e3e4ffb8f5b0a33bccb18eabd5753c"
    sha256 cellar: :any_skip_relocation, monterey:       "9560fd8b32f4585f48d71ac6fbb3fbe3f1f2df80da07783c263fec8690a18e5f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2e7a999a4b19078c4608c0d0aea5fcc8184ba1e8044ef5fbe83b4e3d7caf8e9"
    sha256 cellar: :any_skip_relocation, catalina:       "77227a7de93c87810d2e864b5cdfdf94e900d98f3c25b6c8753077c823847af3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3df4c2f4c1f443981a5df82c755247f29389d96751d7533496bdc20c07357fd0"
  end

  depends_on "rust" => :build
  depends_on "erlang"

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
