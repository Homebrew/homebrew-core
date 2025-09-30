class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/4.5.0.tar.gz"
  sha256 "94a92a520668f0f6712d19d1af9887c3a9444f30e80f73b205befdb1597b390d"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "254b6fff6130e404f66cc29e772c07306422d4c8d0b0b3bfbf48dba351eac094"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "254b6fff6130e404f66cc29e772c07306422d4c8d0b0b3bfbf48dba351eac094"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "254b6fff6130e404f66cc29e772c07306422d4c8d0b0b3bfbf48dba351eac094"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc397e45b96bd8e04dd3bdc8ef135993caec4533b467d8581bf7022086b96f47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59f3eb48c9f8431a92a18294fe51d2e29688ebe9e13a4c4d9b6bb8db6c4c28d1"
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
