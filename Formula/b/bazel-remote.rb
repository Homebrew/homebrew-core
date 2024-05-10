class BazelRemote < Formula
  desc "Remote cache for Bazel"
  homepage "https://github.com/buchgr/bazel-remote/"
  url "https://github.com/buchgr/bazel-remote/archive/refs/tags/v2.4.3.tar.gz"
  sha256 "01a84e318ff7ee4aa72d756c40a6ae9753d2dfaaaf5612fe1c8c8a66ad221bde"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "83d14ba7f6e4516802f44ab937932da92e10dd5b882638d4a30533875b4db279"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a225c9b5bf31ef038040df03648868db7a6caa1fa2d9af830ab06607ac9a4a78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6ae273979792960354093127f879ae6e94c4b4dad5701973c44d622c2a3913b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5fdf1244726d44e93e92bb1012c52787c6584996ea3957354a2ff7dbb63fa29c"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a1444537ef090430f4bbb25efb2be33ef4e6ae6e43364e2d4fe9b83e169f186"
    sha256 cellar: :any_skip_relocation, ventura:        "39e68df4dc6de1ca076e9bcc64bb18e78bed969b49730db4228c7e51c00a0277"
    sha256 cellar: :any_skip_relocation, monterey:       "5613813762a2e1f583e4d422e6c0a886cc890da0db7bc4eb9f7b856891115eea"
    sha256 cellar: :any_skip_relocation, big_sur:        "3286617b7a170b5a3f28002bed706f9be30ee6d9fb99f13e2cd63120ba684387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8913b32477f70a440f5fdb1fec1f57410fd92512ab4dade36a0d63898228137"
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
      pid = fork { exec "#{bin}/bazel-remote" }
      sleep 2
      assert_predicate testpath/"test", :exist?, "Failed to create test directory"
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
