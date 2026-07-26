class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.114.tar.gz"
  sha256 "9c2e2de64041321250733d6acb380e37bb92742cde68fe78bb13c1aa01435d2c"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4030befc35c2f8c7d414d72c94be30826c0d481617ccc21de7dec24b7cde673"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4030befc35c2f8c7d414d72c94be30826c0d481617ccc21de7dec24b7cde673"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4030befc35c2f8c7d414d72c94be30826c0d481617ccc21de7dec24b7cde673"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecb49bc50b3bf509016df1e924c2983e7a11831d421fa64df87df3df363f43a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf0abc74330308472810e15d860f9e04c877774bd4aea58ae2398eaddbf8c3b0"
    sha256 cellar: :any,                 x86_64_linux:  "513958a6b48f17fb08308c33b158b998f47f1eda994bae161cbd9612248e7b32"
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
