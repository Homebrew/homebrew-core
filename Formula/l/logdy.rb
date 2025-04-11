class Logdy < Formula
  desc "Web based real-time log viewer"
  homepage "https://logdy.dev"
  url "https://github.com/logdyhq/logdy-core/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "c9db35d4dfe619ec7af79324568c17db373eb3266f88a25de291cec636a5a1d0"
  license "Apache-2.0"
  head "https://github.com/logdyhq/logdy-core.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f824b88435510732a6b795cf100cd9de6249febc70afa7d339d817a7d7f31739"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f824b88435510732a6b795cf100cd9de6249febc70afa7d339d817a7d7f31739"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f824b88435510732a6b795cf100cd9de6249febc70afa7d339d817a7d7f31739"
    sha256 cellar: :any_skip_relocation, sonoma:        "e48f5faaa1c82aff7dffaa7d9fc55b1b2552b60ca51c3921133eb950402d2891"
    sha256 cellar: :any_skip_relocation, ventura:       "e48f5faaa1c82aff7dffaa7d9fc55b1b2552b60ca51c3921133eb950402d2891"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dee1e1e42f5737edbf37da5cb2c2a16882702063a656436e71af979d6c2ed31f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"logdy", "completion")
  end

  test do
    port = free_port
    r, _, pid = PTY.spawn("#{bin}/logdy stdin --port=#{port}")
    assert_match "Listen to stdin (from pipe)", r.readline
  ensure
    Process.kill("TERM", pid)
  end
end
