class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.55.1.tar.gz"
  sha256 "b3f6c7b0c62a79e05322e4dafd4b101723c70d076621a1c6cc25b9a8aaf55bad"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5f3039985a5550a367448dcaec5f9fd3f2fa00d86df118a52192b280d45d22e7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ee05417f3dc45f7b2dc03cb34a1951a6a9bed53114a66bad1ac66cb5ebce9f1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c504cc6bc9c8ce344fdda9d20089dac9b13265105eccace78849819513edfc11"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bed69c092a6250e7d665662f77db39c95951180c57a304b9350d4a397472ba44"
    sha256 cellar: :any,                 x86_64_linux:      "06a0747a453c8aae441de790be31719769aeaeccb8dda8ba516a8b7ab7be7aa6"
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
