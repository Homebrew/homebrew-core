class Aztfexport < Formula
  desc "Bring your existing Azure resources under the management of Terraform"
  homepage "https://azure.github.io/aztfexport/"
  url "https://github.com/Azure/aztfexport.git",
      tag:      "v0.14.1",
      revision: "f492475b7cbe50b284bba0b1fdb55e150f5fdb07"
  license "MPL-2.0"
  head "https://github.com/Azure/aztfexport.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b78ee4ea925c7b98fe9fc6af55d5deab0a0bf4e6fedcc763b9f823997381057"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b78ee4ea925c7b98fe9fc6af55d5deab0a0bf4e6fedcc763b9f823997381057"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b78ee4ea925c7b98fe9fc6af55d5deab0a0bf4e6fedcc763b9f823997381057"
    sha256 cellar: :any_skip_relocation, sonoma:         "53eb411165b93171922427006c83efe642c46b6b905a56cb8c14e91f5c83bc1c"
    sha256 cellar: :any_skip_relocation, ventura:        "53eb411165b93171922427006c83efe642c46b6b905a56cb8c14e91f5c83bc1c"
    sha256 cellar: :any_skip_relocation, monterey:       "53eb411165b93171922427006c83efe642c46b6b905a56cb8c14e91f5c83bc1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a783b83614d464efa8c62c740139a312ba2d2b97e9fcda3a1b4e8ab6b2f87b01"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'main.version=v#{version}' -X 'main.revision=#{Utils.git_short_head(length: 7)}'")
  end

  test do
    version_output = shell_output("#{bin}/aztfexport -v")
    assert_match version.to_s, version_output

    mkdir "test" do
      no_resource_group_specified_output = shell_output("#{bin}/aztfexport rg 2>&1", 1)
      assert_match("Error: retrieving subscription id from CLI", no_resource_group_specified_output)
    end
  end
end
