class BazelRemote < Formula
  desc "Remote cache for Bazel"
  homepage "https://github.com/buchgr/bazel-remote/"
  url "https://github.com/buchgr/bazel-remote/archive/refs/tags/v2.6.4.tar.gz"
  sha256 "b717b9724127f673e847de4f1a757671b800f5772ee63a148cb04183eeb66b42"
  license "Apache-2.0"
  head "https://github.com/buchgr/bazel-remote.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cf3efbae3bf7f9892e0562be8305ba6f9c60c30ecda3a26e6c01e1641a0bac2a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "71c7ee727cd4039693b067a9b05e79b721c8016c0278b5c1c154f93641a15239"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "99964b04e4b93d0d888bb30bfc7cb15ec8743bf92b52b8952dd6005c1c33dd48"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5192a97b6590ff212acf4b882fbfc0eb152a87219a25d8dd66e5c8338f5bd753"
    sha256 cellar: :any,                 x86_64_linux:      "b1960915ff290394492956a6d2da84eb1fd3aaa859a6a57c666e6722a67ab1d8"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.gitCommit=#{version}")
  end

  test do
    ENV["BAZEL_REMOTE_DIR"] = "test"
    ENV["BAZEL_REMOTE_MAX_SIZE"] = "10"

    begin
      pid = spawn bin/"bazel-remote"
      sleep 2
      assert_path_exists testpath/"test", "Failed to create test directory"
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
