class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.11.3.tar.gz"
  sha256 "02794efb9ad10d52d45aef0df165ce16f431f6ce2408fe8bd0bca06a6e562c14"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b7887bad381ff17685f11a9d5892d09caaaf5292d4ad02399070d711b3300ba6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b7887bad381ff17685f11a9d5892d09caaaf5292d4ad02399070d711b3300ba6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b7887bad381ff17685f11a9d5892d09caaaf5292d4ad02399070d711b3300ba6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c475d86f7d45dd71e6c96a1a9551788fbb07ccc4c345db5a3b8f5888aead3f49"
    sha256 cellar: :any,                 x86_64_linux:      "7d8d4e77e0a437fabbaa2bf3e7201124c2782f0d38b68e5a00035094f5a5db2e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # https://github.com/cloudfoundry/bosh-cli/blob/master/ci/tasks/build.sh#L23-L24
    inreplace "cmd/version.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"bosh-cli", shell_parameter_format: :cobra)
  end

  test do
    system bin/"bosh-cli", "generate-job", "brew-test"
    assert_path_exists testpath/"jobs/brew-test"

    assert_match version.to_s, shell_output("#{bin}/bosh-cli --version")
  end
end
