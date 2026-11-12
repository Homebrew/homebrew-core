class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.55.5.tar.gz"
  sha256 "11f89be8ac4f5ab611670e6f0394b2368691b260077c26dab454051a038e3320"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "abeb3aac02cd727eebeb40bad5f1f4b1196489026479632926f93591a74d253c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2d06065fe8529af0f130cd44135e10adab2138de628ed4b390f30fce594a33d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1454477fc4b1e22ff358083cb34e69a7470f48fdbcdee613416c7ad6c9d0a40f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7bef72bc429215b60312b9c1cf2e7307ce71db95cb8ee42d07532a97f6b6daae"
    sha256 cellar: :any,                 x86_64_linux:      "b04a1143b83cd8bf3ab3aedb7f74da1a66121cf7beb88d8dd0f705027b5c84df"
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
