class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.30.5.tar.gz"
  sha256 "c698a9cbd2766f6df648a49edfb9c9e4f5cebb4b3d469ec7b0b8f5925fe83771"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30e75740a6f8530b55a9cb1c8f9e1faaaa9e9892794707d2778df94301eb3986"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "651a1cb020a7c5f6294d622d13f7d3f8eb80cf279019e7d73e7a57d97ba1fba1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "305a05bc555e229c34452799733ec4a0b2c0c6a43385e2e3fb2044c8951539bf"
    sha256 cellar: :any_skip_relocation, ventura:        "0a796fc992ee7ed1e3ce0350815357a25aefd3e0f8b883075349eecf70cc3069"
    sha256 cellar: :any_skip_relocation, monterey:       "130d1b34fb9915947594ff44e906ec4a60dd0d01624e99e30973599201db0b19"
    sha256 cellar: :any_skip_relocation, big_sur:        "203b6fbf78fc6481840f1d2c96492ffe7418aca0e2f0241574b36af0d8fbe37f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bc90ee1581e3c37830036dfa9e232a869b4e2a3597262bcce06e2a78d7bcefd"
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
