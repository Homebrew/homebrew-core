class Bomctl < Formula
  desc "Format-agnostic SBOM tooling for the stages between SBOM generation and analysis"
  homepage "https://github.com/bomctl/bomctl"
  url "https://github.com/bomctl/bomctl/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "8d361a0813de9aa65a366a1f8333004b2fa476981481c0c90e00ccaf74a01c58"
  license "Apache-2.0"
  head "https://github.com/bomctl/bomctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a80f0acd6667c9b0f50c91abcf5ba91da45e46e384b3ab6f43d8aa4c4848fe27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a80f0acd6667c9b0f50c91abcf5ba91da45e46e384b3ab6f43d8aa4c4848fe27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a80f0acd6667c9b0f50c91abcf5ba91da45e46e384b3ab6f43d8aa4c4848fe27"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbe3c0f247c3af774ea99e69255cd79b21ab78f69692aec41700a4e45cdebd75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce7c85d6255bdcc402702cd830d53b3b17a6fb296e43218025aa9d6186dcd12c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc2c4f8955a62ed561f259b1e26bc4ddf9133f0c6f3b3673a5c2b70440469c19"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/bomctl/bomctl/cmd.VersionMajor=#{version.major}
      -X github.com/bomctl/bomctl/cmd.VersionMinor=#{version.minor}
      -X github.com/bomctl/bomctl/cmd.VersionPatch=#{version.patch}
      -X github.com/bomctl/bomctl/cmd.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable bin/"bomctl", shell_parameter_format: :cobra
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bomctl --version")

    resource "homebrew-testbom" do
      url "https://raw.githubusercontent.com/bomctl/bomctl-playground/4712cefc49fbfbe71362aa1dd1d5dce8339b76c5/examples/bomctl-container-image/app/bomctl_0.3.0_linux_amd64.tar.gz.spdx.json"
      sha256 "01337ee051fac432f124ba4898541e84bc3d6bc97833e01136501d68e252e94e"
    end
    testpath.install resource("homebrew-testbom")

    system bin/"bomctl", "import", "--alias=testbom", "--tag=foo", "bomctl_0.3.0_linux_amd64.tar.gz.spdx.json"
    assert_match "testbom", shell_output("#{bin}/bomctl ls --tag=foo")

    system bin/"bomctl", "export", "--output-file=bom.json", "testbom"
    system bin/"bomctl", "import", "--tag=bar", "bom.json"
    assert_match "testbom", shell_output("#{bin}/bomctl ls --tag=bar")
  end
end
