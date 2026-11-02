class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.12.17.tar.gz"
  sha256 "2f912ee7cb5b071a28eb7642b2bd70111f255355782b8750906cbd569984221d"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e06d3c16607d0350c1a3161f4f53bfc8cb06c66e2d956511f22ae5f97cad5e3c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e06d3c16607d0350c1a3161f4f53bfc8cb06c66e2d956511f22ae5f97cad5e3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e06d3c16607d0350c1a3161f4f53bfc8cb06c66e2d956511f22ae5f97cad5e3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f7a259110fdbe52e23ffae29b64ae7a7e0d6b63d55dc518dfaf44581eb209fbe"
    sha256 cellar: :any,                 x86_64_linux:      "ce95b07d9a5582d42514f43a434f9e15134bb64b23fb1e03c1679b9e638a6419"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.hoverctlVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./core/cmd/hoverfly"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}/hoverfly -webserver")
    assert_match "Using memory backend", stdout.readline

    assert_match version.to_s, shell_output("#{bin}/hoverfly -version")
  end
end
