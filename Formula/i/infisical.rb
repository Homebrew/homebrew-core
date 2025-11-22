class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.30.tar.gz"
  sha256 "3f5f376ccc7e58478d863e6358e616c0b4652ae74b92b6bf22c07129533d41de"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "697cbbb7b5eeafacbd2b7722188ec73294b36194ae616be439fee67459872e20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "697cbbb7b5eeafacbd2b7722188ec73294b36194ae616be439fee67459872e20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "697cbbb7b5eeafacbd2b7722188ec73294b36194ae616be439fee67459872e20"
    sha256 cellar: :any_skip_relocation, sonoma:        "85c9acb42918ce87f2e1d463876dd289ec204752deb11912f5238798513b3e7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d6bee7ce049cd1fbc98ebd88c6ab24b668515dfdb67307e3c75afd93c4a0165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45e33913de891bb35e3f6a799df3ad023f64454a97dc132f90dbfd67b8a68be0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end
