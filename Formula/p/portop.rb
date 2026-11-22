class Portop < Formula
  desc "Terminal UI showing which processes are using TCP and UDP ports"
  homepage "https://github.com/padovanl/portop"
  url "https://github.com/padovanl/portop/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "8f4704988d3c3a5e7febfebe898b49ba81a6604c1fafbff060e761789bc9dae5"
  license "MIT"
  head "https://github.com/padovanl/portop.git", branch: "main"

  bottle do
    manifest_sha256 "1fc7243a92df847c5b148e651ca7bbf36c9428055822e41b2749ca1c61875ae2"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "10a9d918513649913bd81addfb4ea76527b0de71f13bc9e955f59e0ba5b66007"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "10a9d918513649913bd81addfb4ea76527b0de71f13bc9e955f59e0ba5b66007"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "10a9d918513649913bd81addfb4ea76527b0de71f13bc9e955f59e0ba5b66007"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "71868c940bd6d50373c07c8aa45f3149aa2fd640ad5a7a5f3ec86508baf6de97"
    sha256 cellar: :any,                 x86_64_linux:      "5aab1f573b4c5d490af741a12ca60c83fbcccf4c63d8fbd60c3bac67e14001d2"
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
