class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/2.0.0.tar.gz"
  sha256 "37f9e4e689fb81469d7ae3d4926e5641e1f617bc41d7b83456a3fb3d8c3e62ef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c683ddce662d990e08e0f8236637b5c220f071934040269e353d7b8c63375d78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c683ddce662d990e08e0f8236637b5c220f071934040269e353d7b8c63375d78"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c683ddce662d990e08e0f8236637b5c220f071934040269e353d7b8c63375d78"
    sha256 cellar: :any_skip_relocation, sonoma:        "1198a9bb4652183ab28612958f3f775e454c1eb7bf413d7a27043fbe33f322e8"
    sha256 cellar: :any_skip_relocation, ventura:       "1198a9bb4652183ab28612958f3f775e454c1eb7bf413d7a27043fbe33f322e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca62bb569e368cf45ec3f16e39fa9db30feb77f304a64806790b2568ea284abb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://api.azion.com
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api
      -X github.com/aziontech/azion-cli/pkg/constants.ApiURL=https://api.azionapi.net
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azion"

    generate_completions_from_executable(bin/"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion build --yes 2>&1", 1)
  end
end
