class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.15.0.tar.gz"
  sha256 "f2bcb345ebfc110aaf7fe769c07d1579065ab97b42237d1689f1cc6d82635979"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "71de9d8e38144f8a52d8408eb2306c29eafd16e4f220cd7908b43a29033d68e7"
    sha256 cellar: :any_skip_relocation, big_sur:       "1a297cb07b6db84e3f6fc33fe655859e5dedf34a0eb34ccea28ac54816936bdb"
    sha256 cellar: :any_skip_relocation, catalina:      "2e92ef3f2ff6a8719f95af6ae024e9e5b35b0e08645eceb75d7c885000e0c8fe"
    sha256 cellar: :any_skip_relocation, mojave:        "2f77ee78f01c62e4d64a356e02dbb73fc91b833973ba2a1c2989f46a41d92c9a"
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
    system "#{bin}/gleam", "new", "test_project"
    Dir.chdir "test_project"
    system "rebar3", "eunit"
  end
end
