class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/4.12.0.tar.gz"
  sha256 "dca546ee70ab56c8f972b5eabf1088b985232232c4beeba5560fff236b6d28d0"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcc282fc84a53f25f20c917473582443c167b111000213341b45f69bddf20605"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcc282fc84a53f25f20c917473582443c167b111000213341b45f69bddf20605"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcc282fc84a53f25f20c917473582443c167b111000213341b45f69bddf20605"
    sha256 cellar: :any_skip_relocation, sonoma:        "790e07721238eb388aeddfe0396fc17b3e9f97afffdf5d95528bb680dd9634ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b442de79cba2e7a94fe8990bde2f14d6f6f54e7edba0310f63b2ca9bbaaed64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40440d7adf178ba6dc8c70fea82dc22aead6034b14363eed9b3b2b6a16b5f55e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://api.azion.com/v4
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api
      -X github.com/aziontech/azion-cli/pkg/constants.ApiURL=https://api.azionapi.net
      -X github.com/aziontech/azion-cli/pkg/constants.ApiV4URL=https://api.azion.com/v4
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azion"

    generate_completions_from_executable(bin/"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion build --yes 2>&1", 1)
  end
end
