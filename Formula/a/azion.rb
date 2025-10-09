class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/4.9.1.tar.gz"
  sha256 "ce60ea21e10dd4274882ba318ae5791a627c80c67a0de775c7307edf1a01bcbe"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0200b26c5531a35ef88a4729b368ad60b6ef7b78460bcb76ec7f2e9e2a84bc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0200b26c5531a35ef88a4729b368ad60b6ef7b78460bcb76ec7f2e9e2a84bc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0200b26c5531a35ef88a4729b368ad60b6ef7b78460bcb76ec7f2e9e2a84bc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a55d2943b14cb3849cee22c74338ce6d5d049f621715b4530922408812fe5a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed757ae0527169bf3a605f9b40ad69f6878fe8aaf15f653ccf822d6d4a8c39c8"
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
