class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.21.0.tar.gz"
  sha256 "9abd3ec53a2c7758e59d7f9d30ecff25cf193e7c161f380d71293a2d5b82e098"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10a8ebda16172c1b2ece012b418302e07817b14edbe14c4a53f56059c3b52d78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2543522532c65301562229691d8bfe2c4118196bca37ccacbc448347b7749a2b"
    sha256 cellar: :any_skip_relocation, monterey:       "fca924e0badbad3b1781515d59affe3d329f9b7065cc96155138554b1c5e7ff0"
    sha256 cellar: :any_skip_relocation, big_sur:        "90c8029445bd03a75c95e98359a94fd1135257b6ebc85fe02dff87314274f674"
    sha256 cellar: :any_skip_relocation, catalina:       "e23fc75f9b6da21cc4e891cbc30220f62bfe45b6adae5298854da04bd9427fd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b51e06b8c5f814d1237abeed5230b97c0a5f997c2dc0c0533e2dba840181b10"
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
