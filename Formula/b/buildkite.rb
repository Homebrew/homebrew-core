class Buildkite < Formula
  desc "Work with Buildkite from the command-line"
  homepage "https://github.com/buildkite/cli"
  url "https://github.com/buildkite/cli/archive/refs/tags/v3.71.0.tar.gz"
  sha256 "9194630249fea5ccdbb75057921cdb0bb9366aa86e9743d65c18153530458553"
  license "MIT"
  head "https://github.com/buildkite/cli.git", branch: "main"

  bottle do
    manifest_sha256 "e9b6e907093e05169d60234ea26835b24eebaf5214705dfdfe31c110952b94be"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2d183cbb981a276cc509c5c93e62c2c75071d3590e3e742ab04c36e3a18d2973"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2d183cbb981a276cc509c5c93e62c2c75071d3590e3e742ab04c36e3a18d2973"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2d183cbb981a276cc509c5c93e62c2c75071d3590e3e742ab04c36e3a18d2973"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9c6854aaa096232794895a3d39ca9c6c4c78df3b280e918bc569d16168a7eb7f"
    sha256 cellar: :any,                 x86_64_linux:      "6863e0fe8c7efa347f1f49d47600691e8af67ae9f9a6537b6e870198524dc4b2"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/buildkite/cli/v3/cmd/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/buildkite --version")

    system bin/"buildkite", "config", "set", "output_format", "yaml", "--local"
    assert_equal "yaml", shell_output("#{bin}/buildkite config get output_format").strip
  end
end
