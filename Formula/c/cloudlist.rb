class Cloudlist < Formula
  desc "Tool for listing assets from multiple cloud providers"
  homepage "https://github.com/projectdiscovery/cloudlist"
  url "https://github.com/projectdiscovery/cloudlist/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "e75a769df7418f51b011b444c62fd4b758547e2dcc130369f69872a1b6e7009c"
  license "MIT"
  head "https://github.com/projectdiscovery/cloudlist.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ff57b04ea186c9be99e90ef7b2ee67c0484449ae0a8a8f5c60c4104f2e6ef21e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ade0d1a6bf00725c57fe270668e0500577fdbc3f11e01cffe2948fccb9dffe30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ba2fa24605a11a613281aab0d87b4be30bc4f4519b4253a25b75701861eb6a3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "920eda07c530e846b861410778f665d6cfb79ecbbc8cdc512a9e8e0f321e8f4c"
    sha256 cellar: :any,                 x86_64_linux:      "8cb96cfbcdfddc2bef6c4f6a6d836f4dea49f621466f5fd37628a0cb0c457b8c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/cloudlist"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cloudlist -version 2>&1")

    output = shell_output bin/"cloudlist", 1
    assert_match output, "invalid provider configuration file provided"
  end
end
