class GitBranchless < Formula
  desc "High-velocity, monorepo-scale workflow for Git"
  homepage "https://github.com/arxanas/git-branchless"
  url "https://github.com/arxanas/git-branchless/archive/refs/tags/v0.3.10.tar.gz"
  sha256 "916b0c6dc6d4dd8bcb678c75a24833e8d856d0298a71f3f539ed0fc78478cb75"
  license "GPL-2.0-only"
  head "https://github.com/arxanas/git-branchless.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d5a5c4fa1975cc5e69bfdf0db0de0826f2bdffc7f7326fe90e0135db2112b14a"
    sha256 cellar: :any,                 arm64_big_sur:  "f6f523ff52451605120241321e7556466595865ce159e365e17d18b9f2583bfc"
    sha256 cellar: :any,                 monterey:       "fa04977d1c370ca5f71374dede5d9edff95dfacac6ced0eaa6cb49291d658a24"
    sha256 cellar: :any,                 big_sur:        "8693338bd489cf356dcd0fea67cdc96e9a90328a80a65fb33dbf328d3efe5020"
    sha256 cellar: :any,                 catalina:       "f9e52b3331d1a1eab71275c51756123a15cc5e228b6c5ae081a5d7a95dbec884"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3aae22be9066255ff79bc3ba8f91cf669a925790721d1551f4f73abb6edccecf"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "init"
    %w[haunted house].each { |f| touch testpath/f }
    system "git", "add", "haunted", "house"
    system "git", "commit", "-a", "-m", "Initial Commit"

    system "git", "branchless", "init"
    assert_match "Initial Commit", shell_output("git sl").strip
  end
end
