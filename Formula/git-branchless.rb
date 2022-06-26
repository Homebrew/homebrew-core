class GitBranchless < Formula
  desc "High-velocity, monorepo-scale workflow for Git"
  homepage "https://github.com/arxanas/git-branchless"
  url "https://github.com/arxanas/git-branchless/archive/refs/tags/v0.3.12.tar.gz"
  sha256 "a73fa82a961bdc6219499b1a5f818f82bea30e6069701dd3227ce32f6c7ee5f2"
  license "GPL-2.0-only"
  head "https://github.com/arxanas/git-branchless.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53962c81cda4bbe10d80008702213c4988fc23cc424ab7361a013cee8b117274"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e19c5d719f3bdbbf052a06d61bfe9c279391f237dcf209f09ca8436f53f9f77"
    sha256 cellar: :any_skip_relocation, monterey:       "aac1b9d97f7020ad032fbf87739db54a8741c97f36f307c6d1739df8eebf4c6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9c2f9587aa52889075f06732e30a0e1589528af04ea1f8f999d3d274a85123b"
    sha256 cellar: :any_skip_relocation, catalina:       "559b66bc5274fbc1ce27130f3beed497d9af36ed380fd2bd46cade1b4a8e4973"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "149d55d7613de2f649e81f23be5a645101e9d96fb0b20ea80ff20ec9fd60ccdf"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

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
