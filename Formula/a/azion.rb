class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/4.4.0.tar.gz"
  sha256 "7edcfb9a97cebe8c770b0c488f5ee9478fe78dcadbd6c84e9741cd755d821335"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "280b43f6f90063ecd6e4415dac398a9543514a8714bf4b603c653c89a7836138"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "280b43f6f90063ecd6e4415dac398a9543514a8714bf4b603c653c89a7836138"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "280b43f6f90063ecd6e4415dac398a9543514a8714bf4b603c653c89a7836138"
    sha256 cellar: :any_skip_relocation, sonoma:        "a27f5bbc214db74da51b7c928a0be9658d2cfb6f1f93774e80bc61558d92eea0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbefae3f92f02feeb6dc9438ea42343ed5ca2661c523d7e5b1dd2ece3c49a989"
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
