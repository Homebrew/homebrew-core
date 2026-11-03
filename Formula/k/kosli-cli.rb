class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.53.0.tar.gz"
  sha256 "d5835b92fee81f2e4e3c97571357f6790761608597cd8ac4a13dd8bf33022831"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5630d7c910c3affc83ee9e4ddc5186da573755696f831244e7dfeb4410b91f2a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0051366f378601e390bbd2446ede5ab75d9bf5e6a83f260cf0a2943a64dd21dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9d9341b9772aa106b5fe365f4f21736a5af712a1fe4bbf9538525d759b006514"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7688899e611e5f9c3fd8c7dcd29b1518de9467136241b351dd5fd742818549b4"
    sha256 cellar: :any,                 x86_64_linux:      "5515c4f1063674e46a82a6dcbbe78f51a58d056bb5f73c5e65b6b12c728fc5b6"
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
