class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.23.0.tar.gz"
  sha256 "d5b159474be38c3e4c54c3b54442c306a1137f8602141e1545d67e9b8f4c22bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ba8442554f7582d737829121ef96397214212f31c2b62b3de352b9d33de86d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9ff99bedcc22eac4c684599cef69e5bccc9b649bfed256a73c068c475344e67"
    sha256 cellar: :any_skip_relocation, monterey:       "de4c1cf9ca5a644dd6873260faeaf815f0d86463f2e0c355f982944862807f0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "19da8411c7e57db14af62eff4131621b9a0118edeffb7c3d57fc34f4caea7a2e"
    sha256 cellar: :any_skip_relocation, catalina:       "b16efc6390fcf47ddf26286a95a76ff19ec6016ebf50617b1b29aca1cf38dd96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f295158e2f75d0257fbe58a661cdf4a5336117a50efd57f68fd7f7ce2af8057a"
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
    system "gleam", "test"
  end
end
