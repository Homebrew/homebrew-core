class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.53.1.tar.gz"
  sha256 "6e8f3534b38dde30c76c6bec26a57e85534ec781e8a1204f390e656f8d9c70f2"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "47ae69f15d877dba9b0dc67692d3300e74c204f939d5fd7036d6b0eb1faea5d6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e60ac2281d5bb1c5f8a1d70de91c63dbe9e812bf83142941c54eb3992e54c9e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8a4811d3773e9d792b6f56b8250ed78d2503e14acc8158319d3e89aaa20a6bb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "34f40b4d0d2a1a622e24009cbaf7bafc430b9cb9c05514c2954cf1af469444d6"
    sha256 cellar: :any,                 x86_64_linux:      "1f8ab4e9266e548d11b434a4540a199b09564d28026b251065deb29fcaad6b4b"
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
