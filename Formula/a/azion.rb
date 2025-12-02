class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/4.12.1.tar.gz"
  sha256 "4a3e65ce6ef6652d80d54e35da2f0fdf39065e2705fa23cf1bd18aeddeceb7a5"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb31c1e9242107e1037b6da6128dbf694a2356d213b6112a733923c43af2c766"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb31c1e9242107e1037b6da6128dbf694a2356d213b6112a733923c43af2c766"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb31c1e9242107e1037b6da6128dbf694a2356d213b6112a733923c43af2c766"
    sha256 cellar: :any_skip_relocation, sonoma:        "93a6c248eb2e49304b76d11745592a8434ffabf3405e49c64bbc9253520bfd4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b38714d69777e08d7d984138ad994df9a99e4c9c6874cf020b480ce57e329619"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f44ad1cd093e6220e62cb83a0780b150ba733d0c039ade77dd4e7aebae83f73a"
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
