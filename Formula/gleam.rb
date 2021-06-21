class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.16.1.tar.gz"
  sha256 "a3c9990e5adcb384a42c344c72823e38cb92f0f71483c45368626b828fb1712f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "49259d27c5d75651157c5ec31a3a4c3b571664123f6df421263aba2684ef350e"
    sha256 cellar: :any_skip_relocation, big_sur:       "3c36f3e3b129cdc7dfbc3ffb5ea8a01fd036028d2c41710125aec194e25343ea"
    sha256 cellar: :any_skip_relocation, catalina:      "7f51992236957bbc6da1c73ba1779b6831f8aac27a389c84e4289ad2836ef230"
    sha256 cellar: :any_skip_relocation, mojave:        "9f9b3467b162621d987e641ccb8ab76ec5cb969eaa2b44277c5a565d4ddfa7b2"
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
