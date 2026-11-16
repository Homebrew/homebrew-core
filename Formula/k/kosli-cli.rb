class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.57.0.tar.gz"
  sha256 "c78f0e6dd878689c62d5137cd00cb8756905908f08a2cb2031298d31b4b77a31"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "353ed3693e8b3b8bb2916c362af11817cd73f66a744b3d8543b02bfd33fc4bb6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9d5b923b84507bf6cbfc5d7d097a8ec8f88f63a5c9bd87a9637738beab0e393b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c481726faeb252af77a6a824da37f01cfc2e71f16e9967ce491b95330fd7265d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e75455814b9ccabc51f4f3627bcd6dea24176b3e0e16a6b61b55e01216024fe2"
    sha256 cellar: :any,                 x86_64_linux:      "09cd6a1733ffeb57d56000fd97c8b5dfbce89345381273c9a4527001c4eeb825"
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
