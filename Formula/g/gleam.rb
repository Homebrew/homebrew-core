class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "731a34612125ccbfd0caac0a9e6cebd255ec536176ef757203f3cdb8b9e2dfd7"
  license "Apache-2.0"
  head "https://github.com/gleam-lang/gleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f51567c5a4d46460245271959953b960126705312996c83f01a3d119a7abbd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0100d9a473e12be25ac42b78aa8363655aae1da467c60a355e842f401df4f553"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d3b635e4f071595fee381773dc4a3878509bfb9f3be570d535da070ffe910d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "26bf9e9c823b45cc424062b183c3991a0c93a1e9f3e578e1a2f8a4dca0cb1a81"
    sha256 cellar: :any_skip_relocation, ventura:        "f3c024fb17ce828c5b1386262e4ae5e15ca784ab9517550bf972e8aa7679f30b"
    sha256 cellar: :any_skip_relocation, monterey:       "9cf785b44984adceea983d90187e647c205fd3bc37f7051dbfd0eeb54d58f80f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4f0341253fd92cdcb10ee299ee9e05f8a9be5f7b1300ca7049a0af91e5afd3c"
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
