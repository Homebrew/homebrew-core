class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.97.0.tar.gz"
  sha256 "cdb2e51a014707942daac0e9fce7143e8f02efa4483edc2f7b43f7bfac7e3104"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c6a568e761840eb2c48d1238d1e8761f2e704e63d74a02dd0ed9c6b156bbafe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c6a568e761840eb2c48d1238d1e8761f2e704e63d74a02dd0ed9c6b156bbafe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c6a568e761840eb2c48d1238d1e8761f2e704e63d74a02dd0ed9c6b156bbafe"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fbc0a61ef3f382314ce48c91f4a11a0ef1845ae53073df8e5045ef05b66d63a"
    sha256 cellar: :any_skip_relocation, ventura:       "fd08b973b2de73a41ac64298a18e2010dbc475353d8599e654e24a4295738d63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de55bd51360330cd2210d47b909648a15fd8e1389d6cc010133c1e23feba2221"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end
