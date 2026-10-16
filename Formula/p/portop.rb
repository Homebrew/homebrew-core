class Portop < Formula
  desc "Terminal UI showing which processes are using TCP and UDP ports"
  homepage "https://github.com/padovanl/portop"
  url "https://github.com/padovanl/portop/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "69c9d5ac353672905d182da2c6d374d6575a2c3e4d72ebc60b77aea1c6a98454"
  license "MIT"
  head "https://github.com/padovanl/portop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8f84ddc2736cb9173d9d1a31959af756e4d058de849a93f4acfa8d56784873d6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8f84ddc2736cb9173d9d1a31959af756e4d058de849a93f4acfa8d56784873d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8f84ddc2736cb9173d9d1a31959af756e4d058de849a93f4acfa8d56784873d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3dc9174f7b70d07145191a274b2d9257451d2ae6a1ac05f600fe07993deebd93"
    sha256 cellar: :any,                 x86_64_linux:      "b220de7e29a0572cde52f98ffcf24e8a2ee138c88af581befb448a48b3796464"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/padovanl/portop/internal/cli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/portop"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/portop --version")
    assert_kind_of Array, JSON.parse(shell_output("#{bin}/portop --json"))
  end
end
