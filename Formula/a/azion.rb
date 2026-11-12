class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/4.26.1.tar.gz"
  sha256 "b4d603743a0181966764063f4af40a11b48711177b9fb9c0c5d4e7f1cecb09af"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "be0515e7c95bac1abd30cb3cebaffbf3c94d6f370368eba1f3f300610b785bde"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "be0515e7c95bac1abd30cb3cebaffbf3c94d6f370368eba1f3f300610b785bde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "be0515e7c95bac1abd30cb3cebaffbf3c94d6f370368eba1f3f300610b785bde"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9fcd53e13ef4183cd6d8cefd54d64bb196465f6fa2653e4fdec4dd8c20e024a7"
    sha256 cellar: :any,                 x86_64_linux:      "553890bf7d2e5a1ffe4c2e872fa0861e9f2bb8614268c3050b4948f955903793"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.ApiURL=https://api.azionapi.net
      -X github.com/aziontech/azion-cli/pkg/constants.ApiV4URL=https://api.azion.com/v4
      -X github.com/aziontech/azion-cli/pkg/constants.ApiV6URL=https://api.azion.com/v6
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://api.azion.com/v4
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiV6URL=https://api.azion.com/v6
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azion"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion build --yes 2>&1", 1)
  end
end
