class Aztfy < Formula
  desc "Bring your existing Azure resources under the management of Terraform"
  homepage "https://azure.github.io/aztfy"
  url "https://github.com/Azure/aztfy.git",
      tag:      "v0.9.0",
      revision: "a3341dd6789691086c838b3db2b3e7d4e1342be6"
  license "MPL-2.0"
  head "https://github.com/Azure/aztfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "795205276eb37c16f360d73e24af8a79386e5c361b75707e8c62704f824ac612"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "795205276eb37c16f360d73e24af8a79386e5c361b75707e8c62704f824ac612"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "795205276eb37c16f360d73e24af8a79386e5c361b75707e8c62704f824ac612"
    sha256 cellar: :any_skip_relocation, ventura:        "c3a39ba41daaec2e319275f4733724608b6eada2e593d0ec165bbae155e02ae5"
    sha256 cellar: :any_skip_relocation, monterey:       "c3a39ba41daaec2e319275f4733724608b6eada2e593d0ec165bbae155e02ae5"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3a39ba41daaec2e319275f4733724608b6eada2e593d0ec165bbae155e02ae5"
    sha256 cellar: :any_skip_relocation, catalina:       "c3a39ba41daaec2e319275f4733724608b6eada2e593d0ec165bbae155e02ae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41161e9eb4380afce7c09b35d292613c25ae6da14536b17543e6b7279ddb6a63"
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
