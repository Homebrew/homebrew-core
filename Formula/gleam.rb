class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.18.0.tar.gz"
  sha256 "9aead695a3baf2e62b462dbacb588be3f3ac778415afc57ab85087fc7955f0ac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "830000afc81d902711b369ecdb8cdc258015ad38d735c162a64d084a52ec829d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a302f1308e00e73f9a319d6cc50491e627f43ca54bca0402a79951894749b57"
    sha256 cellar: :any_skip_relocation, monterey:       "916e2e52da573c4f2ce85a4e0123ef75c8242da4c944263508df9d2ad614c2f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5d224fc1348e60b39604bea981449d8da80382c6d3e46be17b7eb38b5e76a09"
    sha256 cellar: :any_skip_relocation, catalina:       "746d22a1362f949c8e38d62b9471d8c2b0db7a782188a3b1a8063a8d8277245a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e0f15fecda49b9d4b1e56bd93cc10bd6e161bd0f64bf07257c9df4d46fce4a9"
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
    system "rebar3", "eunit"
  end
end
