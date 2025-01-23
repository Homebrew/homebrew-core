class Aztfexport < Formula
  desc "Bring your existing Azure resources under the management of Terraform"
  homepage "https://azure.github.io/aztfexport/"
  url "https://github.com/Azure/aztfexport.git",
      tag:      "v0.15.0",
      revision: "f1f6ccee9a9f94a11f2006c393a8c27ba7b4d566"
  license "MPL-2.0"
  head "https://github.com/Azure/aztfexport.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3334fbb3d5e7d57770565de8cad4a48c8d65e2df7b5c03bffc07708bef9f6bdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "209bceab0e2b561838c6885d68d0e6c5df55b23c3b22a88a3b114763414d9d0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "209bceab0e2b561838c6885d68d0e6c5df55b23c3b22a88a3b114763414d9d0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "209bceab0e2b561838c6885d68d0e6c5df55b23c3b22a88a3b114763414d9d0c"
    sha256 cellar: :any_skip_relocation, sonoma:         "07234c2c61eef8680e788c6aee60212656545588870a7418164c65793c218651"
    sha256 cellar: :any_skip_relocation, ventura:        "07234c2c61eef8680e788c6aee60212656545588870a7418164c65793c218651"
    sha256 cellar: :any_skip_relocation, monterey:       "07234c2c61eef8680e788c6aee60212656545588870a7418164c65793c218651"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "680c5fa311acfb28554009f87a4d7caf8a5d3b2c97a61fd267d2ae52dcee5e43"
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
