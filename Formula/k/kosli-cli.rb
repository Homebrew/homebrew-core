class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.57.1.tar.gz"
  sha256 "8d961003ac4e08486c034c85dca2eea82f8bb0fa095d604157a3c786cad4dfdf"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f67a06b88c440d6e880e6765b8592873060abab84ea39d2dc9720870ec2727a6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fdeca4f63a1ac5026209649137853d3cb7aa2e1bf1a1ff619f5f3d2758d37669"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2b7d421932e68c5cac28160a8c9cf696d8263957a5a79a0f8f8c94fd4797f88e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e6bf86b7c3c59982e34db98ddff6cb4af65cd699e85cc4d6cf6363f5809d0600"
    sha256 cellar: :any,                 x86_64_linux:      "6158458ccbc1cf554df4572efcc74dce3b72b7b5bc76e8bbc32d57a3aee61347"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
