class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "3d2b781142342bfe56150fa723b5072f4b6174a23ce6c8a6d75a45bdba0b88f0"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e67d0b834597fd15fca890d5d9e560ff899c9d916c393f28c35f6bae9e1d2ef8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b842bf91c871e49a1106e87ebd654b163dbb72ddec71de15b910238f694057a1"
    sha256 cellar: :any_skip_relocation, monterey:       "d445c780a053ef3870ca5f6c2728474d9e637f0fb7ed9fbe124e90c5de0c2797"
    sha256 cellar: :any_skip_relocation, big_sur:        "0929026b63aba3c081a187b071ac078f172c41e68dcbbfcd43b88f9f2c15dee2"
    sha256 cellar: :any_skip_relocation, catalina:       "d9bfcbcc8076639422d65179b292304976061528b0c31cc9a94ff6d2ba03c8d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "316ccdb07db7d7587fd7f1b06857a8d65b15d69df20efe1a525cb7b5ee683646"
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
