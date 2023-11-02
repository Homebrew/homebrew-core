class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "97832d38c128decdab47af25e40358a42dac0aa42350523bb7e00c3b3adf0055"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc2d7f820d2a434cfdbeabaae4b0af8a9c883b5e75e32eb5f8fcf531233ceea2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22143197eaa256499edd40af9f29401e6d4576a1a885fbeca55460e43e24cced"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bb2680dd8c9f29e42fbc946e60583540710a19c3d908e9543e74ce829a4fc86"
    sha256 cellar: :any_skip_relocation, sonoma:         "65581e53207d91be04a0b8f93b351c6cb6fccb6437a00226c13c752191b75b8e"
    sha256 cellar: :any_skip_relocation, ventura:        "0ecd04f337f55cd0e793ff7ad052333f6c96673439bfe23c60280a61db73282a"
    sha256 cellar: :any_skip_relocation, monterey:       "b9e92cb34425b3d3b2c06dd911bc71b5c791a6ea7001fca3a11e2549385bd1b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04fb1f958a419e9e8235e60d561495e67015e79f78467831e150b400307d614a"
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
