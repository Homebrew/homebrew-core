class Aztfexport < Formula
  desc "Bring your existing Azure resources under the management of Terraform"
  homepage "https://azure.github.io/aztfexport/"
  url "https://github.com/Azure/aztfexport.git",
      tag:      "v0.14.0",
      revision: "fb772ba9d0a129a48d2a2a4c26df4eb6f2f7d948"
  license "MPL-2.0"
  head "https://github.com/Azure/aztfexport.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34f9f530e3d23d43d76d0c0901b421ef20ada197d926584dccaa3cec4528d869"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34f9f530e3d23d43d76d0c0901b421ef20ada197d926584dccaa3cec4528d869"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34f9f530e3d23d43d76d0c0901b421ef20ada197d926584dccaa3cec4528d869"
    sha256 cellar: :any_skip_relocation, sonoma:         "601bfd72dc473d538e96183e772bce9b600e8616bfcef50deefeefab1675bb7b"
    sha256 cellar: :any_skip_relocation, ventura:        "601bfd72dc473d538e96183e772bce9b600e8616bfcef50deefeefab1675bb7b"
    sha256 cellar: :any_skip_relocation, monterey:       "601bfd72dc473d538e96183e772bce9b600e8616bfcef50deefeefab1675bb7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dff52d025d24869ae2a8280ef725e556fa670213a57bec1ee8bc1b9739d4a81"
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
