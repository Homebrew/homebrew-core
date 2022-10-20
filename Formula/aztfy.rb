class Aztfy < Formula
  desc "Bring your existing Azure resources under the management of Terraform"
  homepage "https://azure.github.io/aztfy"
  url "https://github.com/Azure/aztfy.git",
      tag:      "v0.8.0",
      revision: "a7c179f0a150fb5ad63206532ea891c1dc0c87f1"
  license "MPL-2.0"
  head "https://github.com/Azure/aztfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83da354f9299b620ffdff845784772bc254bbe31a6fba78c430ad37a52812202"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83da354f9299b620ffdff845784772bc254bbe31a6fba78c430ad37a52812202"
    sha256 cellar: :any_skip_relocation, monterey:       "a38f8a1c8ba65951d1993cacdb4f310524d6b41f11c6251c22020a56e17d144c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a38f8a1c8ba65951d1993cacdb4f310524d6b41f11c6251c22020a56e17d144c"
    sha256 cellar: :any_skip_relocation, catalina:       "a38f8a1c8ba65951d1993cacdb4f310524d6b41f11c6251c22020a56e17d144c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ea928014ffbbc9918f84b96ea7266ccf6862527fce66dcad28c4208b720842d"
  end
  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'main.version=v#{version}' -X 'main.revision=#{Utils.git_short_head(length: 7)}'")
  end

  test do
    version_output = shell_output("#{bin}/aztfy -v")
    assert_match version.to_s, version_output

    no_resource_group_specified_output = shell_output("#{bin}/aztfy rg 2>&1", 1)
    assert_match("Error: retrieving subscription id from CLI", no_resource_group_specified_output)
  end
end
