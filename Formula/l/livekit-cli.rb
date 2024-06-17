class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "ce1ef64f0718f96a32af6187a89526b9be8084050e212be6c3c00f3b370f707d"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0896748800d9ea7dbbe482194d45a085048aeeece890a44b4fcc6cb7df65604"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd0e4acb0e728acc0a698e926473966bbe122e66e0384d8369388d3d1bfb8e92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9b54e0f14a1075f23fa810bfa822f609bd62024c4933228d0817634f4d13e7c"
    sha256 cellar: :any_skip_relocation, sonoma:         "638e2a122d0cb081eb2f6a2cd17bb63e06424c1b0bf62e7fb1b4febf3a948bf8"
    sha256 cellar: :any_skip_relocation, ventura:        "a51bcb7d24d6af87f9de75610eab0c09c7fbc1e06089409b7c832d83c0bfada9"
    sha256 cellar: :any_skip_relocation, monterey:       "48cbf23809bb1db4d59cc1ce5c7698ecb74ffeee37a08eb5db2cdb1b60db642b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "327c6317beff261d8c88516ca9bbe769c4c98488de2c29f0a838de0e3a1218c2"
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
