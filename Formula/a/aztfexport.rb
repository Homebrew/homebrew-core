class Aztfexport < Formula
  desc "Bring your existing Azure resources under the management of Terraform"
  homepage "https://azure.github.io/aztfexport/"
  url "https://github.com/Azure/aztfexport.git",
      tag:      "v0.14.2",
      revision: "523f5b841b8f9454638bdf0654f49aa370431380"
  license "MPL-2.0"
  head "https://github.com/Azure/aztfexport.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d4cfc49579b41fcd437ad3ad52e8b89c6938ea325057d23edfba12552f81b12"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d4cfc49579b41fcd437ad3ad52e8b89c6938ea325057d23edfba12552f81b12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d4cfc49579b41fcd437ad3ad52e8b89c6938ea325057d23edfba12552f81b12"
    sha256 cellar: :any_skip_relocation, sonoma:         "95de0a0332d9aad3abf2618c1a84ddfbf5ea8671741b406d7509e7f3b4f524ae"
    sha256 cellar: :any_skip_relocation, ventura:        "95de0a0332d9aad3abf2618c1a84ddfbf5ea8671741b406d7509e7f3b4f524ae"
    sha256 cellar: :any_skip_relocation, monterey:       "95de0a0332d9aad3abf2618c1a84ddfbf5ea8671741b406d7509e7f3b4f524ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea8f3cdffab8792f9025dcbedbf8a9ad83dfa8b5e65241a53c1f5080d2d54e89"
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
