class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.21.0.tar.gz"
  sha256 "9abd3ec53a2c7758e59d7f9d30ecff25cf193e7c161f380d71293a2d5b82e098"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6979f99a5c171cb15e5c6eccfd69da3689259be5042176c753090065951b646"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3aca17ca3e06bc8238f1ab10d8194e05c0902e572ea68d57910d6d5524780e55"
    sha256 cellar: :any_skip_relocation, monterey:       "6b570c090c466c95c0301b0912d31425a5d585f74057235ce5cd8391ab8a7de9"
    sha256 cellar: :any_skip_relocation, big_sur:        "f57c4bc9ed70cb302ca67d40c483bf958d76dfafc2fb617682f78e9722bf740b"
    sha256 cellar: :any_skip_relocation, catalina:       "96db3c9de8125372d2c4851fc9332ad821c04c0c9559160181524ef46289865e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "541fde1a9f4f0f64fae17820587a6466343f16efa158df81ab61095f18b32dd5"
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
