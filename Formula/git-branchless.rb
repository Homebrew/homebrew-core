class GitBranchless < Formula
  desc "High-velocity, monorepo-scale workflow for Git"
  homepage "https://github.com/arxanas/git-branchless"
  url "https://github.com/arxanas/git-branchless/archive/refs/tags/v0.3.10.tar.gz"
  sha256 "916b0c6dc6d4dd8bcb678c75a24833e8d856d0298a71f3f539ed0fc78478cb75"
  license "GPL-2.0-only"
  head "https://github.com/arxanas/git-branchless.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a061c1106fd9c5480b4d87a781f1b8903403c5af31d6cf1f28b74a9e92191eb7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "496628f2e5df4ef0aa5c39e0d816792e1d2446a072e677d299cfc6431a568d25"
    sha256 cellar: :any_skip_relocation, monterey:       "57211206d595176ac3ffb024fb25f709c675689c9781bccfa63d5c11b22ad369"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d27a02242e843ffee0cce941b9cc7c957ae304ca7775cd271b0ec64d6ee9713"
    sha256 cellar: :any_skip_relocation, catalina:       "9f639c35b9e731be227386e30708e51741c22c39fab9ee0613486fa3cdfe5ddb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8159b41f6f5cd3fe6a0beff554aa3db851078ec9e54ebc967b248fe7002e5e85"
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
