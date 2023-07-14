class Aztfexport < Formula
  desc "Bring your existing Azure resources under the management of Terraform"
  homepage "https://azure.github.io/aztfexport/"
  url "https://github.com/Azure/aztfexport.git",
      tag:      "v0.13.0",
      revision: "a590751bd2c35d276fabc97c54e4cfee54482362"
  license "MPL-2.0"
  head "https://github.com/Azure/aztfexport.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb76f4ea1d207484a8c175a1910d05628872394a42e614401d795513ab807e19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb76f4ea1d207484a8c175a1910d05628872394a42e614401d795513ab807e19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb76f4ea1d207484a8c175a1910d05628872394a42e614401d795513ab807e19"
    sha256 cellar: :any_skip_relocation, ventura:        "aebc920822206879d8f42387eb2b91ad1745c46efa03cfcb58798f696f33b77b"
    sha256 cellar: :any_skip_relocation, monterey:       "aebc920822206879d8f42387eb2b91ad1745c46efa03cfcb58798f696f33b77b"
    sha256 cellar: :any_skip_relocation, big_sur:        "aebc920822206879d8f42387eb2b91ad1745c46efa03cfcb58798f696f33b77b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30e559cdd177fe385022134c269bd790e215c336f1b83495bdf8800cb57772ff"
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
