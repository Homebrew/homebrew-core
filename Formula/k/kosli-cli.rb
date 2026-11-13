class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.56.1.tar.gz"
  sha256 "f0b66d954dce406f1976056063e10a978917415bdbe8119fc7207136a10a45de"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "761c0fad0250fd63290764dfdcd5a34762486d58c6aeaeae77ec37b3c3bce50e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "06673ef575dbac7d859c461a9a333d5a4066b79295135daea668c5f39e8cc283"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "db46922b2c9f52a9bb0ea794c987fa25b91611c55b325e172f22fb9d873e4433"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7a0f5c48d1855314c3ed9bfef76b01f43fe7f09bf45c37b6bedee2a86ddeabaf"
    sha256 cellar: :any,                 x86_64_linux:      "1ecee2e1c79ec0ebb58eaaf6f74a9b6258e9292ba0b51300efcd18aa55ea9654"
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
