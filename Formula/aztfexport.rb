class Aztfexport < Formula
  desc "Bring your existing Azure resources under the management of Terraform"
  homepage "https://azure.github.io/aztfexport/"
  url "https://github.com/Azure/aztfexport.git",
      tag:      "v0.13.0",
      revision: "a590751bd2c35d276fabc97c54e4cfee54482362"
  license "MPL-2.0"
  head "https://github.com/Azure/aztfexport.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c20a2ba2faba5762f693d9dff6fc9671c91150d69635e9412ef80e93cb21248"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c20a2ba2faba5762f693d9dff6fc9671c91150d69635e9412ef80e93cb21248"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c20a2ba2faba5762f693d9dff6fc9671c91150d69635e9412ef80e93cb21248"
    sha256 cellar: :any_skip_relocation, ventura:        "68c303ee6f53834716265c8719c337565c13989cb93c18ce43f6716f4534c6ae"
    sha256 cellar: :any_skip_relocation, monterey:       "68c303ee6f53834716265c8719c337565c13989cb93c18ce43f6716f4534c6ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "68c303ee6f53834716265c8719c337565c13989cb93c18ce43f6716f4534c6ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a83d2d2ee07bd666ea2a140eaeee7552d118b076c0114a1db55052c3ff9ada1a"
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
