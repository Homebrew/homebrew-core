class Aztfexport < Formula
  desc "Bring your existing Azure resources under the management of Terraform"
  homepage "https://azure.github.io/aztfexport/"
  url "https://github.com/Azure/aztfexport.git",
      tag:      "v0.20.0",
      revision: "d52e1c50f4bd40dbd7c514a487afa09d6a2db560"
  license "MPL-2.0"
  head "https://github.com/Azure/aztfexport.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1abc92347edccae85771233af6fbee21ec60cd39f50520184c5823a65a6d9042"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1abc92347edccae85771233af6fbee21ec60cd39f50520184c5823a65a6d9042"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1abc92347edccae85771233af6fbee21ec60cd39f50520184c5823a65a6d9042"
    sha256 cellar: :any_skip_relocation, sonoma:        "c03fa865c45ee5eedf6358daae3991245779a5b332015727d8b1ae31243083a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1dfcaf2b2cfffac99fc7a8b8b77628eb99b13ba1aebc18858d04b9d6c44510c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13926213180bbdc676dd855cd0626eb92fe836c82faf094ac46faa6ce4ffe704"
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
