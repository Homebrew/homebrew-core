class Aztfy < Formula
  desc "Bring your existing Azure resources under the management of Terraform"
  homepage "https://azure.github.io/aztfy"
  url "https://github.com/Azure/aztfy.git",
      tag:      "v0.5.0",
      revision: "f957fc158684aaf66551543327124865c7fe4eca"
  license "MPL-2.0"
  head "https://github.com/Azure/aztfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b92b9d72ac203afb014c060d61be6766b39d676a1c827f6cef52f36aedc4b13"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b92b9d72ac203afb014c060d61be6766b39d676a1c827f6cef52f36aedc4b13"
    sha256 cellar: :any_skip_relocation, monterey:       "dee2f8e188d185fe215f26749f1a4f3546fe421c944c88d1529b700203f92c02"
    sha256 cellar: :any_skip_relocation, big_sur:        "dee2f8e188d185fe215f26749f1a4f3546fe421c944c88d1529b700203f92c02"
    sha256 cellar: :any_skip_relocation, catalina:       "dee2f8e188d185fe215f26749f1a4f3546fe421c944c88d1529b700203f92c02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c164eaf7a02031b4a4c5738bdcbcda0228134a49b3d474e59ed64b1a8a0f33ce"
  end
  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'main.version=v#{version}' -X 'main.revision=#{Utils.git_short_head(length: 7)}'")
  end

  test do
    version_output = shell_output("#{bin}/aztfy -v")
    assert_match version.to_s, version_output

    no_resource_group_specified_output = shell_output("#{bin}/aztfy 2>&1", 1)
    assert_match("Error: No resource group specified", no_resource_group_specified_output)
  end
end
