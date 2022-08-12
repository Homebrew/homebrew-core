class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "3d2b781142342bfe56150fa723b5072f4b6174a23ce6c8a6d75a45bdba0b88f0"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fd84e0f34d09993d558f57ead4041e750e9baa7eee746b28347c72a3fc735e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "155a1af90748ef7cd209ac8c4f7d9317ade8975fb488310068a3a58e3b1b86fc"
    sha256 cellar: :any_skip_relocation, monterey:       "1e76abaeb9aa24b7c8fbea7aa50f2c5ecd3948e847155468d3665106b87081d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1c9f1643b706244dbb926a845d00119587d5c1a2d3490eeb1d657305462515d"
    sha256 cellar: :any_skip_relocation, catalina:       "afaa85702a6cf2060bf5bdf8a04576e52fea1fec0103fc42a6072d55af22a4fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49f9949df3683f0e27e4b2a6890253e177da7ffa7b27eeb2b50737909b86e473"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/livekit-cli"
  end

  test do
    output = shell_output("#{bin}/livekit-cli create-token --list --api-key key --api-secret secret")
    assert output.start_with?("valid for (mins):  5")
    assert_match "livekit-cli version #{version}", shell_output("#{bin}/livekit-cli --version")
  end
end
