class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://minder-docs.stacklok.dev"
  url "https://github.com/stacklok/minder/archive/refs/tags/v0.0.65.tar.gz"
  sha256 "8bb24fce4fbb332425c0df5f321683b66f5ea299a9e6a3fb2ce80c0c5d7a30bc"
  license "Apache-2.0"
  head "https://github.com/stacklok/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db939511080f3eebbd17237c9c3a0cd283526bd8572ff3a7429db3eb198db5eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db939511080f3eebbd17237c9c3a0cd283526bd8572ff3a7429db3eb198db5eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db939511080f3eebbd17237c9c3a0cd283526bd8572ff3a7429db3eb198db5eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9060d8e2ec2d227d641b7f5ebdfcfb004f2d3531bf39bae0dac4ff7c0866143"
    sha256 cellar: :any_skip_relocation, ventura:       "af7dea9ff9c0cc604f32c25c9f29f58096972b763dfa2b45967e7f4cc7eb37e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bd87aa3f749ff0a70ce6d7ea6803032cc83b2129b55fe68e68055f735ed7548"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stacklok/minder/internal/constants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version")

    output = shell_output("#{bin}/minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end
