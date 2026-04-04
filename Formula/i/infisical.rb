class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.69.tar.gz"
  sha256 "7c952a53fa2a5ecbabdbc80688cb49dc417fbcb5c5eb10ab2b9b55f9366d4dcc"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "285a92331d12feaeb5dff24559b504ca514daee1ffa88f10c504e457e24f764d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "285a92331d12feaeb5dff24559b504ca514daee1ffa88f10c504e457e24f764d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "285a92331d12feaeb5dff24559b504ca514daee1ffa88f10c504e457e24f764d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5db934d32b3355d7a08b096fff57bbf0fb081b2e137c7ff1acd5de59a8bf7201"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8726974860de44f14eff125b9fd3ed0d66635c7228af5aec19243ff927043d20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50105366d346271035ebcedd9966aeec82e18fe9f9023a9628b6b64e05a04daf"
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
