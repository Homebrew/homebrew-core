class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/1.16.0.tar.gz"
  sha256 "f7823495f8b8634f10564aac0c02ea95a547631e1754e2b07d0ef93e66057b30"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9101d7543683cf63bf04bf9ed294410fae877c481d119fd268944ae6b9949d1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c981ed700a3c6819887cacedbfc61249d2a9f2610f8c793fd37d15b5f0af0024"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d132aa61ea99af2c9d5dd36846111409d22fea86a3e176df406c27ebae66c55d"
    sha256 cellar: :any_skip_relocation, sonoma:         "06410b4ef5b953e069ac86615ae8aba9facecc011682fa67304c7d6ddd824916"
    sha256 cellar: :any_skip_relocation, ventura:        "81993ce1869b6f0b7844780a4b0800ec56829c00edf4f0ddff5252924d4719d7"
    sha256 cellar: :any_skip_relocation, monterey:       "bf0a170d61b9140793be9cda2fc3c9442405de2cbf518690e2a7fecb4fa75122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08c6d16db5052561bcb204d700b065324891ef11b5489de371df8f39b8b44ac5"
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
    assert_match "Failed to build your resource", shell_output("#{bin}/azion dev --yes 2>&1", 1)
  end
end
