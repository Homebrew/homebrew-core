class Aztfy < Formula
  desc "Bring your existing Azure resources under the management of Terraform"
  homepage "https://azure.github.io/aztfy"
  url "https://github.com/Azure/aztfy.git",
      tag:      "v0.8.0",
      revision: "a7c179f0a150fb5ad63206532ea891c1dc0c87f1"
  license "MPL-2.0"
  head "https://github.com/Azure/aztfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3223262cffd36fd34b96828eaf60c6b91ea3296f7ca8a70a8bb97dc59d16a8d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3223262cffd36fd34b96828eaf60c6b91ea3296f7ca8a70a8bb97dc59d16a8d7"
    sha256 cellar: :any_skip_relocation, monterey:       "248092b3e8792f4278eb9f981e8333a5c06410c4da6ed0c5379e784a9ce9329e"
    sha256 cellar: :any_skip_relocation, big_sur:        "248092b3e8792f4278eb9f981e8333a5c06410c4da6ed0c5379e784a9ce9329e"
    sha256 cellar: :any_skip_relocation, catalina:       "248092b3e8792f4278eb9f981e8333a5c06410c4da6ed0c5379e784a9ce9329e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5742042639aa27ef133d0c80061cf2ffb337e545367021d6931ad188c6e2a7c"
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
