class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.138.0.tar.gz"
  sha256 "7bf0eee5ee6618bec510c54007ebe411b2cc16cfb904c46003d257be4e783c51"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "100798ce9f6a2e80ed42fcec85456478836dbd46f2ea6fb895707baf9121b107"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d5395560a656a8ba3f66ea78c39fcdbeec829ca6c7fdbac274084ff801f80400"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d5395560a656a8ba3f66ea78c39fcdbeec829ca6c7fdbac274084ff801f80400"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d5395560a656a8ba3f66ea78c39fcdbeec829ca6c7fdbac274084ff801f80400"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "de9660b6d83d99f272c71d42947e3beba372c335351cdfae9fdbb2a2a7bf4d07"
    sha256 cellar: :any,                 x86_64_linux:      "918860f3fec9525b93c032aad19876e2e2b6ef42cfb4c0b45fec6d487ba572ca"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "chainloop auth login", output
  end
end
