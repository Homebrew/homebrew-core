class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/4.27.0.tar.gz"
  sha256 "8ce06c9c5e63677bb7b3e0ba0b71d2e24b3caa64b0e113f9942a0bf0aabc1f50"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "main"

  bottle do
    manifest_sha256 "3318b05c7a659de1afbe3bae95ef2eb712d0bc417892facd60b66ba3070312bd"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4cd1ac86a08c3cfbc75e7be9a56a58717240f289b6b0542c239c3e83fc16ec06"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4cd1ac86a08c3cfbc75e7be9a56a58717240f289b6b0542c239c3e83fc16ec06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4cd1ac86a08c3cfbc75e7be9a56a58717240f289b6b0542c239c3e83fc16ec06"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e023b94f49fac41d6e801198c4e054971bc8d4bd3c8dd9fc1d05560d79fc1f17"
    sha256 cellar: :any,                 x86_64_linux:      "b632a51c84c04e69047c547d2c99033267ae996c5d99de39b3928cbd2b0a2ec3"
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
