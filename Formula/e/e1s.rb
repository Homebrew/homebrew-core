class E1s < Formula
  desc "TUI for managing AWS ECS, inspired by k9s"
  homepage "https://github.com/keidarcy/e1s"
  url "https://github.com/keidarcy/e1s/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "d2846602a86b245ca85e0f80d3a02f5cdeb6320d12b87189894f1cfc5531ac28"
  license "MIT"
  head "https://github.com/keidarcy/e1s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_releases
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "079be6764c8e19e17fa3a67a97fa48619623abda1db780697d147d5481074777"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "079be6764c8e19e17fa3a67a97fa48619623abda1db780697d147d5481074777"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "079be6764c8e19e17fa3a67a97fa48619623abda1db780697d147d5481074777"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "079be6764c8e19e17fa3a67a97fa48619623abda1db780697d147d5481074777"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "18c98a16ddaa6b8d57d1e11022c239cad08ad4e31c9e0e91668800097faea1d2"
    sha256 cellar: :any,                 x86_64_linux:      "ff4d2390b72eab0b4e371c7309bfe748303c1667e072a5ec0193c72f85002074"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/e1s"
  end

  test do
    ENV["AWS_REGION"] = "us-east-1"
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    assert_match version.to_s, shell_output("#{bin}/e1s --version")

    output = shell_output("#{bin}/e1s --json --region us-east-1 2>&1", 1)
    assert_match "e1s failed to start, please check your aws cli credential and permission", output
  end
end
