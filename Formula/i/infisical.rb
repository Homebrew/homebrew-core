class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.103.tar.gz"
  sha256 "9a4c3fa47a15cee7020493ad64292d7673142b33086baa1450b90f65938030e3"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8097910b1b3842c1fb0eda4c95404d6860449f705e5ebb59296c34c31795ae51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8097910b1b3842c1fb0eda4c95404d6860449f705e5ebb59296c34c31795ae51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8097910b1b3842c1fb0eda4c95404d6860449f705e5ebb59296c34c31795ae51"
    sha256 cellar: :any_skip_relocation, sonoma:        "6854f3a0170de90033111e7a06761c7644724a8039d6a12528e54b22e550c46e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11bec7ba1c4cd648f4cc4f2ca18cf000ac74bab88681ffef000cd128b629bba4"
    sha256 cellar: :any,                 x86_64_linux:  "2d2f36cf00b28cda646f47544a5b9e264f2e3ffe04c0e5d8b4d48575bd845ca4"
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
