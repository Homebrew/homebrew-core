class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/4.9.1.tar.gz"
  sha256 "ce60ea21e10dd4274882ba318ae5791a627c80c67a0de775c7307edf1a01bcbe"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf8a35a530c0dbf091b5e1258f7fd0159f182c6825010c670695baa6f5834ba4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf8a35a530c0dbf091b5e1258f7fd0159f182c6825010c670695baa6f5834ba4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf8a35a530c0dbf091b5e1258f7fd0159f182c6825010c670695baa6f5834ba4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4c3f4939d6982dd2f1fad8b886aa83368cb454c3f9d4180e3e3d8ab86382b80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf58050a8d62e657cfe1ea0187dddb1e94d34ab0b6bce9b9dddcf0c32acc997e"
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
