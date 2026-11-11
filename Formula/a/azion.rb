class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/4.25.0.tar.gz"
  sha256 "cba985f168d78d82bfebbb3d399e649dffa1833b11f3b7145a41f1f716c7f2bb"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a2f3d9c1f49d6f33013e904895c64bbb1846e00db9e9a45b2b06213aba3b315d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a2f3d9c1f49d6f33013e904895c64bbb1846e00db9e9a45b2b06213aba3b315d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a2f3d9c1f49d6f33013e904895c64bbb1846e00db9e9a45b2b06213aba3b315d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5e9d1b1d01c52214367cc3a221d72d6d76009f323739c9e84052949d7dac3ac1"
    sha256 cellar: :any,                 x86_64_linux:      "5641fd563e4193c6c323a0db8e567d921074f9534d572bb7b3f5d5576806212e"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.ApiURL=https://api.azionapi.net
      -X github.com/aziontech/azion-cli/pkg/constants.ApiV4URL=https://api.azion.com/v4
      -X github.com/aziontech/azion-cli/pkg/constants.ApiV6URL=https://api.azion.com/v6
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://api.azion.com/v4
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiV6URL=https://api.azion.com/v6
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azion"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion build --yes 2>&1", 1)
  end
end
