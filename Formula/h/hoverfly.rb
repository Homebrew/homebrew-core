class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "499d2e17868095641606a8504f23896759792863e3a8525bd6e663354494afb2"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f20d4d6207a3fde3c9e7e40fdd93a6c68dfcc9e035d5ce91da10b354f9f4cea1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f20d4d6207a3fde3c9e7e40fdd93a6c68dfcc9e035d5ce91da10b354f9f4cea1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f20d4d6207a3fde3c9e7e40fdd93a6c68dfcc9e035d5ce91da10b354f9f4cea1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f20d4d6207a3fde3c9e7e40fdd93a6c68dfcc9e035d5ce91da10b354f9f4cea1"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fafff4289bb6b87854f57d5dbe5fc209e6b93a1aa632a37aeb814afe5b6c95e"
    sha256 cellar: :any_skip_relocation, ventura:       "8fafff4289bb6b87854f57d5dbe5fc209e6b93a1aa632a37aeb814afe5b6c95e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f01e86a6fd2704d077dd36536e7cd55ed3e1f96f1289e7d72f2e91cbc168660"
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
