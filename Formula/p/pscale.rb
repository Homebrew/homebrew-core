class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.353.0.tar.gz"
  sha256 "af462c093f041bf20dd0fd28317cb75e70bc60c403e96d0fec862c9c8d980223"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0533385fa51226ef7b718414abada2100f296053ee32538812f49235bc01fb46"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b5e42ba68f54e634c7319439733cbd5dbd7d048a41f6467342966c8c4e3ecae8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "79e2dd37c13b9a14d42f02ac3b72b97a1d7dbc3445337e1a26b3c51610c0481a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0ede8562e4a6ee690c4723c63caaf853ead6f6b67115e4a8ed6fef832681d604"
    sha256 cellar: :any,                 x86_64_linux:      "bea2ec32252c76b7441acf3d3c0a4f3cdcf0e5bb0a4aaabae0cb605939dafed7"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
