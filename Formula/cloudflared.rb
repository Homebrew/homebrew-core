class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2022.5.0.tar.gz"
  sha256 "65ad3379f21736fbbda6bd95f23860af9491274fd25b75780ccd9693b332a3f0"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c57673c788197e62d089ebe0a60a1c5c78505671ed680763345e4469244ccb7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "baa1645c47a973c4a62573250a7171a1c7aa6bfad4a9b36ae5944beb4e5d4f2c"
    sha256 cellar: :any_skip_relocation, monterey:       "cc0a47d9d93ff18d63e782a873b6b72a662557a2e3357d6ed35b39b0aad5083e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d21f4289d683c1c7e6bf60a4d3791cf738767a9cbf9ee8207d5409f5d0d36cbd"
    sha256 cellar: :any_skip_relocation, catalina:       "ac9f9a5691d6616419960a9de0adbbce734aebb26c573bd0daf3413beaf200d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3000c04dacd0197d0f3b0d4021da3dfe4c2493de57e423c1ef759634b6fe57c0"
  end

  depends_on "go" => :build

  def install
    system "make", "install",
      "VERSION=#{version}",
      "DATE=#{time.iso8601}",
      "PACKAGE_MANAGER=#{tap.user}",
      "PREFIX=#{prefix}"
  end

  test do
    help_output = shell_output("#{bin}/cloudflared help")
    assert_match "cloudflared - Cloudflare's command-line tool and agent", help_output
    assert_match version.to_s, help_output
    assert_equal "unable to find config file\n", shell_output("#{bin}/cloudflared 2>&1", 1)
    assert_match "Error locating origin cert", shell_output("#{bin}/cloudflared tunnel run abcd 2>&1", 1)
    assert_match "cloudflared was installed by #{tap.user}. Please update using the same method.",
      shell_output("#{bin}/cloudflared update 2>&1")
  end
end
