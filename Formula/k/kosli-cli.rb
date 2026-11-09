class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.55.3.tar.gz"
  sha256 "babc27419bb5076ea66d01029909107f78a2a5140c967f8e5ae9724e8632c85d"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0e90a342061f981cbb5aefdc08b4e122213e9b2729ee6d1649aa554a835b1f88"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a23213b733eb277fff95a547992f520749efb2bace189ba2b06369a3ba16978a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cdd0b3f915fd7286dad2b54a2ebaf1306dfa6a3657383633beb86017c86be7dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2bff81a51e5507a34058bd29e8d1dfe0770d2708f95e183ff9c6036dc9c2ea1b"
    sha256 cellar: :any,                 x86_64_linux:      "c1f0a8a176e8f95b6b3d263495aa5ecdead2a66b5df0b4ccd7d8bce17a58fe84"
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
