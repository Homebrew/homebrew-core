class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "7ced040b0289faff08ef2ff8113e9ecf06e2c7e3ac9154a529fa3b9bf1a4ade0"
  license "Apache-2.0"
  head "https://github.com/gleam-lang/gleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57797e1ca6c180355473767574d365ec30dc9831895e82beadde24f6943e93e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "660444981b4c06fa9795c71562d014af8611e7d5361b32a84aa6de260d01734c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c72cc426d55ed4b1e70800f92c27b4e6bc449d21690f87f38b590f2c28b2dd29"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec4c53b539a01d37625d7a32d2fad0a84e8abba88b9d14f3fbb69a4d19247813"
    sha256 cellar: :any_skip_relocation, ventura:        "c6ad31fa127ae7c0a9a70181a76cdfac3245ab15034be35d32e54a21a29feda3"
    sha256 cellar: :any_skip_relocation, monterey:       "b409bd74f3112f208349bd2dadb630f6381e6d88bfc0378a48078588ab23bbee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "754feebba28c36199ffb87d694cb33f6ba5fc5a28c88a523d3eb62847e43b665"
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
