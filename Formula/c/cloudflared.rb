class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2024.2.0.tar.gz"
  sha256 "62d8b3c32fcddee24e22707a22b4a33a014cd9314471e069f991fd359a102d75"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d239d7ff7f3ffe47b57e109f0ffc4cee522fab2c1dc19782be03ec2679e439c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07722a5687c2bd4cfecc2780cf86a4dc6b3bac67f2dda220f35ad4c260d4e4e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b719358aad51309a363c3e8ac54a49f24284ea1bfa43d75a138bef4662bf412"
    sha256 cellar: :any_skip_relocation, sonoma:         "dae8ba297b36d11f249a8f60181cc42d2126265989ca0ec942ec3337574d1a3d"
    sha256 cellar: :any_skip_relocation, ventura:        "63e2d63e4b3235125a6fb3b0f688e64935a566ac57877d181a93ec52331e759d"
    sha256 cellar: :any_skip_relocation, monterey:       "cb927a3ab0ff15cac218cd4c42caab5975006687e26e1c251069ac2b6d4e6e40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29ee8e983b4d4e67e771a7d9a888a59a0cd59272666d0ebf639e5736f3c21e91"
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
