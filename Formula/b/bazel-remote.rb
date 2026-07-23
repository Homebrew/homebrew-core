class BazelRemote < Formula
  desc "Remote cache for Bazel"
  homepage "https://github.com/buchgr/bazel-remote/"
  url "https://github.com/buchgr/bazel-remote/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "3e8765b849996d073cc8e9a3bbd7d7575a49c041f01c9a8ae13725fc951142bc"
  license "Apache-2.0"
  head "https://github.com/buchgr/bazel-remote.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f354e4941f9f99ab37dd95fa8578da65b0498f1f53128a12b8ba7c03e1da9cb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18f1a604a9dd0eb29d54bcfd56ffcb27a921ff3677d17b32748f31f13bf39f81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc74694c87cff83c41ea21d8ad045cf83c51c81895d62e23ecf112c3a4ec8b12"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfa80430581fc37829e9295ee9cda247c74f9ae8efeb710c3ed6eb18f47a76db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38369493b4d39f8694081a064e3536304d1a78b172ff8687cc37849250c176b6"
    sha256 cellar: :any,                 x86_64_linux:  "ac2cd1e7f51773a63005d282db150a0463268c2700de758a9eb7b7ce841b699e"
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
      pid = spawn bin/"bazel-remote"
      sleep 2
      assert_path_exists testpath/"test", "Failed to create test directory"
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
