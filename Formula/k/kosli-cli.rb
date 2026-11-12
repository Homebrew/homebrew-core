class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.56.0.tar.gz"
  sha256 "f6fc6983483ff01c92ba9da7e0a34c9ff64236ff3f74f142f834aa90310edd74"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "16c54a0a79b5403908afa985ea602143f3d2587fb19477db8c83e93250a962ce"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "431ab9f50abfa3cc8bccda04a20c63dadcc27ca727bf164d94a3e532e0180ea0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4f0fbd21e6fab422dd7d73c068f7f7d63c3186441cd67396b797052b868180db"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4ffc70081885340537fd9b20d74dbd53827c46c00b5e6e1d6a56194b0fdc1563"
    sha256 cellar: :any,                 x86_64_linux:      "2c4fe4d6367bfd3c8e8ad18deca2e252299d38c909dc9665b3e55d84218f2e3c"
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
