class DroneCli < Formula
  desc "Command-line client for the Drone continuous integration server"
  homepage "https://drone.io"
  url "https://github.com/harness/drone-cli/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "f19786bb5da9e506f6d175c0639bfd0a3f8acf8487ac575a54afba222e0b70d7"
  license "Apache-2.0"
  head "https://github.com/harness/drone-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37626e0ade2e2b7c103e6340104645027985986195a56bc2152edee6e022702d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23c5ccc940a32a1161cf3bd08ae94ac2975f900937befe9c8647d31cb3fcd0d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23c5ccc940a32a1161cf3bd08ae94ac2975f900937befe9c8647d31cb3fcd0d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23c5ccc940a32a1161cf3bd08ae94ac2975f900937befe9c8647d31cb3fcd0d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "72b2623cbe6e8319cdf8a8b1044116a59215698b9004a34405f2e1f4c8a66216"
    sha256 cellar: :any_skip_relocation, ventura:       "72b2623cbe6e8319cdf8a8b1044116a59215698b9004a34405f2e1f4c8a66216"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "843947dbc29fa19b8309c3bbd004b4237954eef1f696d8c5d51c50eb8af4412d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edbf3ac83206ebc7d2272c111ec6fc63cf24fd305d65149bd3e4e0aac8ec96db"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(output: bin/"drone", ldflags:), "drone/main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drone --version")

    assert_match "manage logs", shell_output("#{bin}/drone log 2>&1")
  end
end
