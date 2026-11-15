class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/refs/tags/v1.19.2.tar.gz"
  sha256 "d8796325dad02802dccc91568a90a00e43247cad1d87ddbd9779a99d3c435d61"
  license "Apache-2.0"
  head "https://github.com/gleam-lang/gleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b5a18ad9cc83d7b33855568bdc29811a397983c152c5716b066395fef36110db"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "89f6a4040884815da8f32aa2af895b55306cb62cc55788c599b9ff2c3068c548"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a531eff6be045f8fbf100e1237b43eedf10602f4dd26c37e6a24f29571988d30"
    sha256 cellar: :any,                 arm64_linux:       "b94ebfff40328edc4038e557bb701b4298adaabe000da3cda166f8b0872a248a"
    sha256 cellar: :any,                 x86_64_linux:      "f3b094bc4319daeff30906698fb6854929e1c9c43121fbec17f412c2286889e9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "gleam-bin")
  end

  test do
    system bin/"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system bin/"gleam", "test"
  end
end
