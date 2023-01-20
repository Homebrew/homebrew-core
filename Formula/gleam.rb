class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.26.0.tar.gz"
  sha256 "65654bbe285a41a637c71a5b3d1c828d9994de44e5543e720409d22e2c2e642a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5946a4c7fdf37b3f1c62fe38ad32b4c087d475d2d2ec29ebf1ee89ad553eb111"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b45f0b795ca20adfb3e8840f06a5857abaccf75a1ad3430dda01e74e359f39c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "500292cc45add36dcd05a0ea9e6a669f3cfd47786bbc8644949d330f58e4a259"
    sha256 cellar: :any_skip_relocation, ventura:        "992d1664c7172c1e9410becfc6c767fd9b94f44432012c68f19c2692e050e2c6"
    sha256 cellar: :any_skip_relocation, monterey:       "486e691c8cd139612489e74e5662ae1546e320d9b02f5116a9c1c9544105e7d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "3491afb7650d5df3206bd6258d409ead645bc60723c6ef9e28bff63382c1cac5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e11ad53c389b0267efd902096d5a5d9b7974a7bfb3b37a443e5ea40f4adb195a"
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
