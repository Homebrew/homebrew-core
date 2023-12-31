class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/1.10.2.tar.gz"
  sha256 "4b2dc44126240abeadbdb8a95232fbb70466ef117afed8a21f6d0bc12f73a03f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2d944a0cf341a64252f47da52e96a6fe1cd1fb2a6151ffb723f7e7e33751be1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7071375ced5b72fd40f548136126ce1868926de7c80b60440e52018978048e1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ecec66681e108f9759b1e1cf630876be1d5d254d272a16bdac1ccdc822375f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "3eec1d0f14e853172876dd7db733d68e0caed240446fb309e8b2f4f89cf465eb"
    sha256 cellar: :any_skip_relocation, ventura:        "910d5cf81539cbc10253c8f45e24cacb4065bc6207015263f75b3f327a885412"
    sha256 cellar: :any_skip_relocation, monterey:       "2f131ad3e5398b3759ec555817b7f07759b89a2c89bce9d071909e44e0d02cba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9205615d8f47440788cfb24105e1d280db7349c1dd850889e77e8c7bfd36e5c6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://storage-api.azion.com
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api
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
