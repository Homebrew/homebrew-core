class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.124.tar.gz"
  sha256 "f5352aa11a5ed9020ac4a499087cbf7fa422a6b2a8de8cfe28f5836360d04b32"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "726bda8d1b21ee15f37680ae005f9e64eec50fa8fdc60b5ca9c3dcbd76116c64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "726bda8d1b21ee15f37680ae005f9e64eec50fa8fdc60b5ca9c3dcbd76116c64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "726bda8d1b21ee15f37680ae005f9e64eec50fa8fdc60b5ca9c3dcbd76116c64"
    sha256 cellar: :any_skip_relocation, sonoma:        "70477525aa2d880d4a32dae795451b988ffb56d1867587c27033c518587e9e3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "350b3c8fe2cd54a8460dc193975e35c7de5c85c8551769ffa578335b8e3d1d17"
    sha256 cellar: :any,                 x86_64_linux:  "5269f14fc3f1baf935837b6b0b187ab138bbb4ee6dce0d8aaab18463e23368b1"
  end

  depends_on "go" => :build

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
