class GitSync < Formula
  desc "Clones a git repository and keeps it synchronized with the upstream"
  homepage "https://github.com/kubernetes/git-sync"
  url "https://github.com/kubernetes/git-sync/archive/refs/tags/v4.7.0.tar.gz"
  sha256 "e63fba896f024f72849d134f0832dfca475126c90e8efd55ed5241fe57bf3a8a"
  license "Apache-2.0"
  head "https://github.com/kubernetes/git-sync.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52a12ad908d18009ef8f38dedeecbf8672c6d6afb895bc6b24d9894475dca274"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52a12ad908d18009ef8f38dedeecbf8672c6d6afb895bc6b24d9894475dca274"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52a12ad908d18009ef8f38dedeecbf8672c6d6afb895bc6b24d9894475dca274"
    sha256 cellar: :any_skip_relocation, sonoma:        "428947d92e83b438801c57112198f7af62154a6438ede53a8cd79187842469ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c0a75d438711a383243e683efdaa3376c52d4e711443edbbf27f32b7a3f933e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78bdd78eda50c128574c46ddf2eff8347ab7d811dd9e9c3310c737cda3acbc75"
  end

  depends_on "go" => :build

  depends_on "coreutils"

  conflicts_with "git-extras", because: "both install `git-sync` binaries"

  def install
    ldflags = %W[
      -s -w
      -X k8s.io/git-sync/pkg/version.VERSION=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    expected_output = "Could not read from remote repository"
    assert_match expected_output, shell_output("#{bin}/#{name} --repo=127.0.0.1/x --root=/tmp/x 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/#{name} --version")
  end
end
