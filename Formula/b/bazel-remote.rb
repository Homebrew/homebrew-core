class BazelRemote < Formula
  desc "Remote cache for Bazel"
  homepage "https://github.com/buchgr/bazel-remote/"
  url "https://github.com/buchgr/bazel-remote/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "fb75cca030f16ffd6105e9c92946768eb1cdcb86cf8c7c55a6c71ad82c695b10"
  license "Apache-2.0"
  head "https://github.com/buchgr/bazel-remote.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6653191d150db313cd2af8b196c39a70e67f2b2e2874ec355a0279ccc5b9dc64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "686bb6762e0e784b1cb5e6a2f5a7fa17173af0f124a964de34e11507ae84166a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74922b67b721ba919b3dc2162c6ad922987a636635a6408fd0365bd3924153d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d918f0ead02c2bd1ad3b9dc3ae49bce57b3256b41012cc6f864c6f2d18945e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8341be94949dc9faa178d2b8406f46b3da67304d29962ecd8b5297a31b80c70"
    sha256 cellar: :any_skip_relocation, ventura:       "f59e1e1c89a90aebd657f0018db579ca2c664e316b2f38b6e4752d7caa1e88ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a1e3c72ba3bedfb3698dad41b67df4f2acefbf2af7b977ff43a29e0139601ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08689c4106138fb419f86ea32d022857552c4d4e83462e9bdd331e4413e003aa"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.gitCommit=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    ENV["BAZEL_REMOTE_DIR"] = "test"
    ENV["BAZEL_REMOTE_MAX_SIZE"] = "10"

    begin
      pid = fork { exec bin/"bazel-remote" }
      sleep 2
      assert_path_exists testpath/"test", "Failed to create test directory"
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
