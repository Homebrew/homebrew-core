class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.3.2.0",
      revision: "717d50b37ba1678673fc810cbd63f7c85b6e026e"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed21f7e945368895e75fd74ababe03bc0d7565b227c16a37bcc310744b445ef0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed21f7e945368895e75fd74ababe03bc0d7565b227c16a37bcc310744b445ef0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed21f7e945368895e75fd74ababe03bc0d7565b227c16a37bcc310744b445ef0"
    sha256 cellar: :any_skip_relocation, sonoma:        "922b404bbf1901b292c583019dfbe2675cf139da6f5422a337f482cc83bbf9f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cfb9b81760a2203d863cfefdde16f0e6b748df38531e54445f71d7f50f196c7"
    sha256 cellar: :any,                 x86_64_linux:  "59533ac084deed15b4678a6ff82eda9bbf7de0a2bc0e71dd829f9913ceff3981"
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
