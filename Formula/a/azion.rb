class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/1.7.0-beta.1.tar.gz"
  sha256 "457c433a3b663d0020842f1ed120550e1d25c6f072b51798d6276c43064fec50"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0f7c48ac4bb250b428d3ac9a7f7d89055bfc42207a83e84ab67b8fe9235fae3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab7816da6b52320c377bb939f00d7053986201f0b5c25ddd0e35cd42a808356f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6ee9a927fc017e7bcbd2e57a2ece6d724dd0638406e083a5eb77e188aa69c8b"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3d1d42108c0040615aa917aa8f89ed117910e9d9e90a230e9f14cb1a963173b"
    sha256 cellar: :any_skip_relocation, ventura:        "60f40cc5fea20303a64cc6b3c9cffea6dae1e78b93010ee00292c89cd80d2ebd"
    sha256 cellar: :any_skip_relocation, monterey:       "7f5e6dc90550d4f1206e3376c3c28f27b8eb37ec593a602121e6dfa78fd18899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb84f57cc8602cfee6fc5cc2f8c15b21b4796c7b453f30a0723728c568fc1ac6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://storage-api.azion.com
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api/user/me
      -X github.com/aziontech/azion-cli/pkg/constants.ApiURL=https://api.azionapi.net
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/azion"

    generate_completions_from_executable(bin/"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion dev 2>&1", 1)
  end
end
