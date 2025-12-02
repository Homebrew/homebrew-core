class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "d842587c739d7471c10be48838c57451df417e97450979319ace477c223d760d"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aac9b90c4043417441e468d1b720499f0217608c4d96e5ef6d324b3a03bcafc5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aac9b90c4043417441e468d1b720499f0217608c4d96e5ef6d324b3a03bcafc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aac9b90c4043417441e468d1b720499f0217608c4d96e5ef6d324b3a03bcafc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "001a8c399565cccf3188cf8d58aa35d3d2708c3dbab114f680779ba193961bee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d56edf2a63431fe2b04ed41cf5f7e22571de978d1c6b73f3d96eb3d92d3c179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3982ff227011df3282a22fadb9b7bda9d55c89175302bb89f71243131e4e0fb8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.hoverctlVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./core/cmd/hoverfly"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}/hoverfly -webserver")
    assert_match "Using memory backend", stdout.readline

    assert_match version.to_s, shell_output("#{bin}/hoverfly -version")
  end
end
