class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/2.27.1.tar.gz"
  sha256 "1e4fbb97bd4abc383cab079d5b9ecb4a1a7ebb9f005713fc2848e8516d72deab"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6865737050b7d69a8e50a288aff71785fbb2117df078afd3922cf74e93faf2cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8d586f4518ef84eda008843db2749c3550e5d419758fc2862b8f66303564dd9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "175f29c87176f0d2f30bc55f3ce53e17ee2419d0cf532bc3c249bad606bf991e"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7c2dee1efa660fbf34d273c17807331c4538237f24a37996dddff6ff5d9f8dd"
    sha256 cellar: :any_skip_relocation, ventura:        "c619a9ff1871034704ec54c685b620dcf93facc61cde2abc1b7d8a914c7e0f7e"
    sha256 cellar: :any_skip_relocation, monterey:       "0bfdbc1d3ca319969b4172f2863af16c37bd74ed617fec8de2a35850dacb0423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58049983a573c1bc9cf670c3431b460fb3fce66c57f17dcb8ee158d642049bf7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:), "-tags", tags

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "Your context is not set",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
