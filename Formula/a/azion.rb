class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/1.6.0.tar.gz"
  sha256 "01660b53f553b657dbb24efa252ee404770acfe816e915cbcba839162ef3215c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce75911ec0ded86f6746900ae36b3947f8c328ea194d28de63cda82239bb1fb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7828d708a5ed1e7fcf03450bcb9a387bf55e9024a874bb5bb23a3a8650221d69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1497cc13bfa56db822f1ea6ff68ac3d3e059fea4593848e2283601fceea813d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d480cb4ad6f2a7f441138013da02698d1a256ff4dd5191fdd8bc5ea73d21142"
    sha256 cellar: :any_skip_relocation, ventura:        "5ce99d76d7c3de501db392662e68791b8265b407644b457bebaa91547004461a"
    sha256 cellar: :any_skip_relocation, monterey:       "bded880527c9811033952526d981726db356faad4c59b6166e3270c21ad13173"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88d187af753534f04189996dfbe1282b6d1b882a2f70ffd53b23563669f441e3"
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
