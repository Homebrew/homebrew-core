class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2024.10.0.tar.gz"
  sha256 "4e9a86e1ead708cd48a00d3739483b60cb77879c3e0b6cc6d89ee6ea9be4d7a0"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f644d93f8451b54abf627ab0585d11073c6f10992d8b14c1b33e52d5d4f9f5dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d091d33aa14cd5172fc69fc818a4ce7c936390c8b31bd10ddac0364aee5a9abc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ff64e3a250e4d6eb01320eba08f59b2eb260fc6eb8bf506f4c31e2051973789"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c02de00ceceb57a88c41ec6f47fd52284c75628babdfeb2680cb9dfedf7b84d"
    sha256 cellar: :any_skip_relocation, ventura:       "4b479f89189b44beb337a9376ac6f9339c411f07eb41bc407782817cc4bb2e83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c92c6c7c9f8d747c61c8ec50510dbb7c79815215385f9648f0a945cc43029f67"
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
