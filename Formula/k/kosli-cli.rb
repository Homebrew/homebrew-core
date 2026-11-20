class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.58.1.tar.gz"
  sha256 "c151f45831cdbd23e43f7531bb0e3126c6b3546e83c56da80d3c10b243b1e0fa"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7cf286e9d14a0e850c8dc38df61dea448662a3bb4b0aec1549457f5c279d6f02"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fde180504e3f190efb2f3ab6d1e3cd0645d83e8b8a1aee6d16268400ef8366b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b25a569dfaad47c19478e1b5535c56cb02cc99ca040a25bfa6e10d14e1e185c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "be69db480f54396b2d5f1ba0a9831b8bc21df0fccec7f803d6ca9788fa181a27"
    sha256 cellar: :any,                 x86_64_linux:      "7f832cdca8ba791716c0535c72512e1a96e35b7622bd46b8e4648d8ee2f41165"
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
