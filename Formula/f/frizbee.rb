class Frizbee < Formula
  desc "Throw a tag at and it comes back with a checksum"
  homepage "https://github.com/stacklok/frizbee"
  url "https://github.com/stacklok/frizbee/archive/refs/tags/v0.1.12.tar.gz"
  sha256 "bc4129f8650f76fad90dc754a746927f3c13fcd62bf6e332cf1c6f9a3ef252b4"
  license "Apache-2.0"
  head "https://github.com/stacklok/frizbee.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "29f72e88e376dcc681fe7a13fa675ae5f56a0c7f047e058102c8d43f85dcd871"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "29f72e88e376dcc681fe7a13fa675ae5f56a0c7f047e058102c8d43f85dcd871"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "29f72e88e376dcc681fe7a13fa675ae5f56a0c7f047e058102c8d43f85dcd871"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e9fb102cbb9e874f12f03b6353d00e6e49a7a621992c27ef243b4f7994fa6054"
    sha256 cellar: :any,                 x86_64_linux:      "0db6590c90b455cd477a0f902a7756da3e2ccd342c9158e172e5d3bd8dda9236"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/stacklok/frizbee/internal/cli.CLIVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"frizbee", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frizbee version 2>&1")

    output = shell_output("#{bin}/frizbee actions $(brew --repository)/.github/workflows/tests.yml 2>&1")
    assert_match "Processed: tests.yml", output
  end
end
