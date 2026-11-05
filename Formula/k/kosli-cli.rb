class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.54.0.tar.gz"
  sha256 "93ea6b830b2b17706a08515d66085c743591498935cfe6cd10ea8e3998465b39"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "73d924eb83b7993795d9c2b5487671d05205ae3c6d4898617a408f1875b19609"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "00914d09ea5471cb90160e6f788ca578939ab38d09a5f25f86e9f4c9c3907a2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eeea67424c377694b97a70d2c768c557a8c6623ac87d13ac96f7a39f6780484e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "414f4b44314213b70d3ad8a4e1269404837963854d36e03a5afd7f3f0e365770"
    sha256 cellar: :any,                 x86_64_linux:      "aef306db2d5d867117c775a294e3d8d95ff26c1dd8ff8a49515aa5612bed972a"
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
