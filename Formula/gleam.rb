class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.14.2.tar.gz"
  sha256 "8fa8b3d7fe07f3cc3f3e143d113b20d51258c3d2a7a151fa28edf3f5bb6bf53d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8ebb3e21e388314ae1d0e422da426d709fb750eb55b5665d54846f7147207a69"
    sha256 cellar: :any_skip_relocation, big_sur:       "183c3d64728822bca628ee01b6dea61084c62932931f549d6cef7243a942d400"
    sha256 cellar: :any_skip_relocation, catalina:      "0fce2b3d6dfdd9f5c84f5c72f1c9576e1a81082a315eaa16bd6df564224c5b5c"
    sha256 cellar: :any_skip_relocation, mojave:        "57fbf00ea61551f31661cdc32f2701225c178d58b3637b271a90bb9834ac122a"
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
