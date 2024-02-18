class Noseyparker < Formula
  desc "Finds secrets and sensitive information in textual data and Git history"
  homepage "https://github.com/praetorian-inc/noseyparker"
  url "https://github.com/praetorian-inc/noseyparker.git",
      tag:      "v0.16.0",
      revision: "6fac285015b6e07bc8eacc020d3f3f270c0bfe2c"
  license "Apache-2.0"
  head "https://github.com/praetorian-inc/noseyparker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "50db564b661533644ea94832f316071e72ffc389bfd141bf5b75fa701f81b991"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "618257cebb32da10f5803e603ed5c52a4bc41fb6f45ce6b861254c6d69b57b0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e75fff4e3e797b363abea1252560e0e0df4a4f03be24e1d099d7c836ad7c5c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "1929f054176f90fad51b8e12ccb762b37dce51ac67fcd9f42288d7c7e1f5273a"
    sha256 cellar: :any_skip_relocation, ventura:        "6eade6cf7f29fe67dbe86338664648110fee2b5bdb97c33f82f62806686e80b7"
    sha256 cellar: :any_skip_relocation, monterey:       "3021a1791fc2ba45f62e17a2f68fec392594e3595eb6c8d9900c0d8bdd7bcb52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aef6fa1f6f54bd512083100d37073b9a411e8a608dbb358a8910bea71e723288"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/noseyparker-cli")
    mv bin/"noseyparker-cli", bin/"noseyparker"

    generate_completions_from_executable(bin/"noseyparker", "shell-completions", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/noseyparker -V")

    output = shell_output(bin/"noseyparker scan --git-url https://github.com/Homebrew/brew")
    assert_match "0/0 new matches", output
  end
end
