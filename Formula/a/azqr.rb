class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.3.0.0",
      revision: "ac2e6784a0af1e5387ec303a8d75e6583e05af6a"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "346331cd394e62bef807c26da39d719db6c43a5099dd12ff364755cb640e0269"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "346331cd394e62bef807c26da39d719db6c43a5099dd12ff364755cb640e0269"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "346331cd394e62bef807c26da39d719db6c43a5099dd12ff364755cb640e0269"
    sha256 cellar: :any_skip_relocation, sonoma:        "94fab781500dc449064b2e23d89533329cfee3410b3fcaf36f5544762f725465"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecf570c48cddafc7925d4739bdded5e121fe1b1dcd23b21dd123588b8cdf0031"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91736c9e8f2fe8f395e80818e6391312f840cb73e9b08be43e72e613934e2b98"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Azure/azqr/cmd/azqr/commands.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azqr"

    generate_completions_from_executable(bin/"azqr", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azqr -v")
    output = shell_output("#{bin}/azqr scan --filters notexists.yaml 2>&1", 1)
    assert_includes output, "failed reading data from file"
    output = shell_output("#{bin}/azqr scan 2>&1", 1)
    assert_includes output, "Failed to list subscriptions"
  end
end
