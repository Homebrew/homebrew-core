class GitBranchless < Formula
  desc "High-velocity, monorepo-scale workflow for Git"
  homepage "https://github.com/arxanas/git-branchless"
  url "https://github.com/arxanas/git-branchless/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "a79e5a63ef0322defe5b918ed62d576d30681b0a16b12e57d6b5ce17096bff4f"
  license "GPL-2.0-only"
  head "https://github.com/arxanas/git-branchless.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7abef4d45e8d02edc34efcfb3b3f283b589fa109d37eed6f71f76fe9bc85fd3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c65f5936a1f25cb26f8adffd381f756bcc3e8ecfc754fce9edf8e15b7df822e7"
    sha256 cellar: :any_skip_relocation, monterey:       "6d51dfb0daeaf23b223c28edeb310a76efc211528028dc55df4324bb9db05009"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f19f476e3d2f8222a7ad733b845bce3ebe672aa7a4a01c8054e76f90f9e3e64"
    sha256 cellar: :any_skip_relocation, catalina:       "5bcdf8eefad3412aeda382737364e40b6e7c5768eec8c6b9d5c2e51cf7f86a61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "335ff8cf5ab5f374e5193cffd3691f161ce9e51f28195a542b5bbad0b40a5ba1"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "git-branchless")
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
