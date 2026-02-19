class Aztfexport < Formula
  desc "Bring your existing Azure resources under the management of Terraform"
  homepage "https://azure.github.io/aztfexport/"
  url "https://github.com/Azure/aztfexport.git",
      tag:      "v0.19.0",
      revision: "9949c60f26721c45b4e8a470fc9c921146ee9160"
  license "MPL-2.0"
  head "https://github.com/Azure/aztfexport.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17d6ac76357f0d14269f333ba6d24a2824d5b1be8e44656cdf2baec885a57f03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17d6ac76357f0d14269f333ba6d24a2824d5b1be8e44656cdf2baec885a57f03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17d6ac76357f0d14269f333ba6d24a2824d5b1be8e44656cdf2baec885a57f03"
    sha256 cellar: :any_skip_relocation, sonoma:        "6db2ce1c76f929d24e20ade80bc54b240c2ab6b5e526086660a88ceb0b57cff0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa28f882c85a2a0e1cbcfe9a37bb8c8dc21681bdc09e3dc2c93b684382bafd4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67ae721579552390be22c9fa69f428988c4b2e070638ecea479564f8d533d718"
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
