class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/4.19.2.tar.gz"
  sha256 "f8b5a21acb246c20c0ca08f6cb97e375e732b24d5698727b881c4290f2feefeb"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe726faf2362196f16ccc892e586c846486ed05ad4a88772fb327736636c149a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe726faf2362196f16ccc892e586c846486ed05ad4a88772fb327736636c149a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe726faf2362196f16ccc892e586c846486ed05ad4a88772fb327736636c149a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c3ad1d905a7c2937fa10c5e9cdf763949640333f329757aeaf73495df32c659"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f08ee92b8a6793bdc96c5b7b0edf65fc8b06a0954873f3bef324598835d56d18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7989413ac2b1496cbe5135576f21e02755fa6af6c81b773bc8985fc4ab9db01d"
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
