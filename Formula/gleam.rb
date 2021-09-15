class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.16.1.tar.gz"
  sha256 "a3c9990e5adcb384a42c344c72823e38cb92f0f71483c45368626b828fb1712f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "396555316a6b09c357ae75c25961febc20465e3d9728d1cb71f6081f9a3ccd01"
    sha256 cellar: :any_skip_relocation, big_sur:       "70d4e606d7f33c752d07fbc3b192cac067df730f7ff19c5a421c64c718eb1aef"
    sha256 cellar: :any_skip_relocation, catalina:      "d1e870e3224a9105c696c567dacf71874a83d5420f5fa88034939d0e15305f16"
    sha256 cellar: :any_skip_relocation, mojave:        "7c89e151a87885c77ea26788e9672eeaa300f8da7276a244536b114db9b17434"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea36a6fe66ab9f9856c2a96727463b2ee67f89c4c797df9b04fe3fc70a9cc829"
  end

  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    Dir.chdir testpath
    system bin/"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system "rebar3", "eunit"
  end
end
