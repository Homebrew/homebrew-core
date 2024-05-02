class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/1.21.0.tar.gz"
  sha256 "7b25af14de5971857244de2b2d7c0b3936543f28d8b35a5ee2a033f735c99169"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ecd26743387784255ff2cbe330f78989aed1e206c4ef5fe13089d038fe539c02"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "deff6cb5a8ea473dfbc4ae098248a4e5bde62f7a77d22545fe2a20619cb63602"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b89b7cfdc4aaa3c975dc168c3666f9f5ef88603942f13d8947829aba7245985"
    sha256 cellar: :any_skip_relocation, sonoma:         "583c65d8767c63c7baa1e79e2920f9b213e199ac7f2ca218b0e46df71aa11307"
    sha256 cellar: :any_skip_relocation, ventura:        "5dbb8de3a562060760421ede6a06680ca16cb7369da9bb6cdf12c896031e8e85"
    sha256 cellar: :any_skip_relocation, monterey:       "46d628d2208d140823a24ca2bb791466bf56fde9c75554bdbddb4c602dc8ec17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "803adc5eff7ef2982434ca53bf5417b0e2ad750c586ebaea31f9accbb7f16a29"
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
