class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.45.13.tar.gz"
  sha256 "00b2475a3f16a24e9bc1842972cc62f1d2f74fba111f7c767b544738a920c291"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5d2878aa40fdbde694ab6340f666b02bf0f333d953ac60da6b55ef3ab45be67a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5d2878aa40fdbde694ab6340f666b02bf0f333d953ac60da6b55ef3ab45be67a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5d2878aa40fdbde694ab6340f666b02bf0f333d953ac60da6b55ef3ab45be67a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a853528bbe55b2196db41e1e26255bb815f3ab8b211a379151a75d8691a0c8f4"
    sha256 cellar: :any,                 x86_64_linux:      "a718c39c544ef45e560a2cd559477472215820372caec0cdae813fe21fc97415"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"infisical", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end
