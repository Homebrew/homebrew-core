class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/4.14.1.tar.gz"
  sha256 "868663d2c654fe2da881291923ba0e3b4bb630d7312ef7fc8f2d876b3930b7dd"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83357c56dfa082f4f65f6a58343968ed7216ea61c48bf59b27b2c08087c38083"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83357c56dfa082f4f65f6a58343968ed7216ea61c48bf59b27b2c08087c38083"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83357c56dfa082f4f65f6a58343968ed7216ea61c48bf59b27b2c08087c38083"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fe1c296c61da2cb36103334284bc9d1cf38b6aec12ec7e8aeca950ace5f47ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27fa2690f0a5ebd414ba113148805c3dc214426ead41e8403c9eb7f8b315a1b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f895b3c661199972024290bf5e0279c516124038c8314af64f072b148001e140"
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

    generate_completions_from_executable(bin/"azion", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion build --yes 2>&1", 1)
  end
end
