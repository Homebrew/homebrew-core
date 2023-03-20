class Aztfexport < Formula
  desc "Bring your existing Azure resources under the management of Terraform"
  homepage "https://azure.github.io/aztfexport/"
  url "https://github.com/Azure/aztfexport.git",
      tag:      "v0.11.0",
      revision: "a70eab527442ed3866285fc0337c59eb20ccca70"
  license "MPL-2.0"
  head "https://github.com/Azure/aztfexport.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e678fd1abc9ede6b6a7c7b281796a179325931daa164d47ed4ad80f03341f4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ee995b7f1a42863f15795ed9b49bbf744ffdcc43ecbd9bb05b24c5d2491e6bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9aa3ca462827c7f4ec3c7f00c3c11bf58290c51931df705db1a34c4ad9a8da8e"
    sha256 cellar: :any_skip_relocation, ventura:        "bf26e803b476d5101992f8d4e0d9ad801c75657a39c6e2fed5a3ca8bc49b4a22"
    sha256 cellar: :any_skip_relocation, monterey:       "2547821d682c0de97a12bb1702b54417f79d00c79d1e10703b58bca69e1a627b"
    sha256 cellar: :any_skip_relocation, big_sur:        "bebd48162a75624981452a0ba508bd5788ecda78f27a3f04ed10e55768354c3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8628995c5d3b0c4eeb74aa1735c21c3ed676cc1275b1b6a3018125f1435c4696"
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
