class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.5.0.tar.gz"
  sha256 "e538d1b743103ee7a65b102e5ba1108b8b3a620cf52d52d89dcf838508447472"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "81cf388198b8795b96620253a592a9d838ff184f9f6a881542d9aa47fc8cbd56"
    sha256 cellar: :any_skip_relocation, big_sur:       "fbf56004a105cd52f56dd0c23f2a1417c128427cd626d7878c21cc059e1a2e88"
    sha256 cellar: :any_skip_relocation, catalina:      "b5d5c423019a88bb221cd85d52d76b740909ded277c94e7016459832fdcf85de"
    sha256 cellar: :any_skip_relocation, mojave:        "6b5eb4269731bbe722105121dd1ea2a3fbf9a51d6c1780a0b2000286b3d8f6e0"
  end

  depends_on "go" => :build

  def install
    system "make", "ioctl"
    bin.install "bin/ioctl"
  end

  test do
    output = shell_output "#{bin}/ioctl config set endpoint api.iotex.one:443"
    assert_match "Endpoint is set to api.iotex.one:443", output
  end
end
