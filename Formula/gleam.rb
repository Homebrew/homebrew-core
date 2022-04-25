class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.21.0.tar.gz"
  sha256 "9abd3ec53a2c7758e59d7f9d30ecff25cf193e7c161f380d71293a2d5b82e098"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "232780427848513598cf80669cf9aff43d2548ede43147b635f49a77cf764aad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2966723885481e02882cb772cdab026f2616357a4e5318997672bce27e00e49d"
    sha256 cellar: :any_skip_relocation, monterey:       "d672f08b95657df30feefa4d577ef60b5d4eab96ee99f96b5c4f37053715cfc0"
    sha256 cellar: :any_skip_relocation, big_sur:        "c634e2b37c0b39feb1deead9a5fed9e15fd700a069152b2a7a7f6ce95ba2c346"
    sha256 cellar: :any_skip_relocation, catalina:       "d51fe54518b404f0b46f62bf17aae4683ddc4c20f9ab72d9f2ba4c0a216e5fc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bedc8e408ac69e964ff3025f556284315e432a4ca4c81aa2e8a15ccb588ebfa8"
  end

  depends_on "rust" => :build
  depends_on "erlang"

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
