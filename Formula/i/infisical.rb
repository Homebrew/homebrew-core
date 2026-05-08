class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.82.tar.gz"
  sha256 "2808f6fed53d7f04690868163022ca7c52f803e72cfd8cbf34f45f5e5d2beb9d"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d278325b78b06f4ffea504f9a067b5e7bbe596d0fd1a368b9dd0a6168fdcaf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d278325b78b06f4ffea504f9a067b5e7bbe596d0fd1a368b9dd0a6168fdcaf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d278325b78b06f4ffea504f9a067b5e7bbe596d0fd1a368b9dd0a6168fdcaf9"
    sha256 cellar: :any_skip_relocation, sonoma:        "27cc8ba88c121e15939de72f825ff007bb7fc6bda11d246396096b3ad716927d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca5e8e04b9e1735564b60b892ec969ea1762aafab2eb101f1b29ef37d94a324d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e11c5ca5c7f620ee00c366a021e88a0c2aa4ce4afb9ee58f45fc4f78570c7145"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
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
