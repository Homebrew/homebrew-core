class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "94dc5787759b5390100f52ff5f7046f033aa817e5b01065536a048d6f2ffd9fd"
  license "Apache-2.0"
  head "https://github.com/gleam-lang/gleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9d469a04133d3efc89224f766f12b5cb6e9599a8283ab7da6cc17880a3876c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42b11c7c551d00378a5bc371dee13e019d2fdb6a22b27467c07a8c6a1fd50623"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6fad5b6278e30444622274149661970f61f84187e90e2f75a8654e526f7cfa9"
    sha256 cellar: :any_skip_relocation, sonoma:         "2fcef037090d830258dc8503385032c561c3411782b0b43d41188ac25deee824"
    sha256 cellar: :any_skip_relocation, ventura:        "e236feb92b03d69b8851048502541512f892b893e835a8bf55f70057f9f6957c"
    sha256 cellar: :any_skip_relocation, monterey:       "f332bc2161c30e4dc29b4af73df42f02ada6baf4bd6721637bae3a858da9b75b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7847651e48929df5f11032eea7b44e2ce225dd948e52319f37d1b32c7c88e413"
  end

  depends_on "rust" => :build
  depends_on "erlang@26"
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
