class Aztfy < Formula
  desc "Bring your existing Azure resources under the management of Terraform"
  homepage "https://azure.github.io/aztfy"
  url "https://github.com/Azure/aztfy.git",
      tag:      "v0.11.0",
      revision: "a70eab527442ed3866285fc0337c59eb20ccca70"
  license "MPL-2.0"
  head "https://github.com/Azure/aztfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2ef51acb9609c1f2944842e36305e2d37ce018ef76af5cafb7664a4aa683f7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01be18f7bca7d2d4842e69e1746b248cb4de09bafd37f75165c1cf41c661786a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee80674a29d5e71d3fde6c3275dc63134b4f8100eb2acfa4d4929e9b104e663d"
    sha256 cellar: :any_skip_relocation, ventura:        "fd74009be7d009c46b86df8ea49628afb9746c6a95f62fd9787b1490d7f4b453"
    sha256 cellar: :any_skip_relocation, monterey:       "ef86277636eda736bafe58a95f646c3bd38551ca4442ce35bd57e5355565420d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2cdcbe0268e618f3990ed58e9586cd270533a9afb3a2806859d821c6e07b28f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3613fa8304a515b311cf2b778c48ec33ac8e0de406e770f71536e0259cece38a"
  end
  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'main.version=v#{version}' -X 'main.revision=#{Utils.git_short_head(length: 7)}'")
  end

  test do
    version_output = shell_output("#{bin}/aztfy -v")
    assert_match version.to_s, version_output

    mkdir "test" do
      no_resource_group_specified_output = shell_output("#{bin}/aztfy rg 2>&1", 1)
      assert_match("Error: retrieving subscription id from CLI", no_resource_group_specified_output)
    end
  end
end
