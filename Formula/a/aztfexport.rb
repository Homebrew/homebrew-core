class Aztfexport < Formula
  desc "Bring your existing Azure resources under the management of Terraform"
  homepage "https://azure.github.io/aztfexport/"
  url "https://github.com/Azure/aztfexport.git",
      tag:      "v0.13.1",
      revision: "c690456672104b905d7ccdf703d056d6785a9bc9"
  license "MPL-2.0"
  head "https://github.com/Azure/aztfexport.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5516289353798b0e5d7693e60921eaa646bc1ad94134ef3784ea9a027c0dc8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5516289353798b0e5d7693e60921eaa646bc1ad94134ef3784ea9a027c0dc8b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5516289353798b0e5d7693e60921eaa646bc1ad94134ef3784ea9a027c0dc8b"
    sha256 cellar: :any_skip_relocation, ventura:        "07cc454845dd6f24e68a9d446cf02369d14b451c4e5c799f965edb38b9cab970"
    sha256 cellar: :any_skip_relocation, monterey:       "07cc454845dd6f24e68a9d446cf02369d14b451c4e5c799f965edb38b9cab970"
    sha256 cellar: :any_skip_relocation, big_sur:        "07cc454845dd6f24e68a9d446cf02369d14b451c4e5c799f965edb38b9cab970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9056b7aa993abb3ce43d89abebeecd26a049e28da7489429488a62521b881fd7"
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
