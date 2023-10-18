class DroneCli < Formula
  desc "Command-line client for the Drone continuous integration server"
  homepage "https://drone.io"
  url "https://github.com/harness/drone-cli.git",
      tag:      "v1.7.0",
      revision: "c75a1a82d46e687d2d961115c849bf3a137b8e9d"
  license "Apache-2.0"
  head "https://github.com/harness/drone-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "002758637d8a801317305b11f1995618b28c3ba2beb03509dd673de30c8a9010"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "472e935c44edd6772746d83e64b7b6ba26c41ff2eb70a8b57967371ac1f17279"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "472e935c44edd6772746d83e64b7b6ba26c41ff2eb70a8b57967371ac1f17279"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "472e935c44edd6772746d83e64b7b6ba26c41ff2eb70a8b57967371ac1f17279"
    sha256 cellar: :any_skip_relocation, sonoma:         "e98a58ade5961ab0282336260e9405b7d7a8add1661220001336951d2118963f"
    sha256 cellar: :any_skip_relocation, ventura:        "b00d9cc103564fd460e84cfd28a748dbfedb8558b2fc43b72cd0760f0770b0d9"
    sha256 cellar: :any_skip_relocation, monterey:       "b00d9cc103564fd460e84cfd28a748dbfedb8558b2fc43b72cd0760f0770b0d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "b00d9cc103564fd460e84cfd28a748dbfedb8558b2fc43b72cd0760f0770b0d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d25092e50d68f78bc010ec2a6cdb779970a9ae72aaea11f8ebca90c8bc0438e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(output: bin/"drone", ldflags: ldflags), "drone/main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drone --version")

    assert_match "manage logs", shell_output("#{bin}/drone log 2>&1")
  end
end
