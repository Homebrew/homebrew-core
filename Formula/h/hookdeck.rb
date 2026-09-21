class Hookdeck < Formula
  desc "Forward webhook events from Hookdeck to a local server"
  homepage "https://hookdeck.com"
  url "https://github.com/hookdeck/hookdeck-cli/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "141af8ff0bdb357310cb8662e5107a3b9928a4a44ce361a1928d65947d5e7383"
  license "Apache-2.0"
  head "https://github.com/hookdeck/hookdeck-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f39cd6f951d3d726209294a20d12fd08bf941a835518b00af757caa021a3d33f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f39cd6f951d3d726209294a20d12fd08bf941a835518b00af757caa021a3d33f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f39cd6f951d3d726209294a20d12fd08bf941a835518b00af757caa021a3d33f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0c34c42bb269ddf921c03839b88a846b8ac002e2898c790453115f7bf3c16fbc"
    sha256 cellar: :any,                 x86_64_linux:      "eb9797146c921feae1ccbd536710d01438c15354de77c03f5a3accb1c7f92147"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/hookdeck/hookdeck-cli/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"hookdeck", "completion",
                                         shell_parameter_format: "--shell=",
                                         shells:                 [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hookdeck --version")
    assert_match "Provide a project API key", shell_output("#{bin}/hookdeck ci 2>&1", 1)
  end
end
