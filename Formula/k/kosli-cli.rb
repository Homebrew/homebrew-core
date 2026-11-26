class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.60.0.tar.gz"
  sha256 "7fd555e53413d965c1aca743e1bdc89565e00f0f99bcbbc26e77ee76ff11b145"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "22f4a0780c840c33d2b7b568cc00e0e5544bc71ce4c4120c7e3abae0466e782b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b011774c3593a4946e42aca51869bda800243b0863eada370e5f22938f9709bc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "66f493f7a95a1553f9b68e2384cec1a1ee2211bb523f8bf8b1adac7b7537a4e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3c89915dd0e8b28d1278fbbc3f75200f50a11493a261d96a68a791dc61de6dc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9a541069b8dd972c26fff90fbd210167ef2ad108637cc059705afbc6d944a2e0"
    sha256 cellar: :any,                 x86_64_linux:      "ee826495abad4246678acff7decf0d5995ef9826474e84302b07d8531b0ed3c8"
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
