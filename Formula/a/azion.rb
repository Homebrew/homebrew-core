class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/4.8.0.tar.gz"
  sha256 "1c1ac08d176a7a751beb7cf931ab872be5bcc9dd277f10755d2a6c5ba33d46c0"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c63eba5f329a786f36aaab9b002990ff4a067e1c7dcd21914ef050092294926"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c63eba5f329a786f36aaab9b002990ff4a067e1c7dcd21914ef050092294926"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c63eba5f329a786f36aaab9b002990ff4a067e1c7dcd21914ef050092294926"
    sha256 cellar: :any_skip_relocation, sonoma:        "d27eb452ca5fb7a9ffcc2e8c72815bf823b0d3dab1200586eeb748daef760ffc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36340395f19018080f4fe7ec8867d84af3020b487e4cf1411eaf11b57b427089"
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
