class Aztfexport < Formula
  desc "Bring your existing Azure resources under the management of Terraform"
  homepage "https://azure.github.io/aztfexport/"
  url "https://github.com/Azure/aztfexport.git",
      tag:      "v0.21.0",
      revision: "102efbe46abb01649b7c6dbfa49da5a8704bf180"
  license "MPL-2.0"
  head "https://github.com/Azure/aztfexport.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9abbe5c279bfd4a7e413de5d2137d1d7d3ce229e4386c518227e82ef916b3482"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9abbe5c279bfd4a7e413de5d2137d1d7d3ce229e4386c518227e82ef916b3482"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9abbe5c279bfd4a7e413de5d2137d1d7d3ce229e4386c518227e82ef916b3482"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a7af68f8606ccf0e8bca9263953dd33ae11a8a9e60332c6ee0910049a9948602"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "61c57b219070a58188815db21fe3792f0351bb7008b5e9eec03a4f68258df5c1"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-X 'main.version=v#{version}' -X 'main.revision=#{Utils.git_short_head(length: 7)}'")
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
