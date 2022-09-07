class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2022.9.0.tar.gz"
  sha256 "be1362bb66071aa8d5c55c60db2be558a69a87054048827ed633e1bf4e98ed70"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a92a62fbd8f59a729a0169d99d1e48dda8a1fb9588f2928ec6a5e9845f019ac9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f10704ae27c334f7f5d96fc9e9ca0b7d526bb63548133cdf0fbcd0b87c592307"
    sha256 cellar: :any_skip_relocation, monterey:       "00a5c0221a796e71f6f223c75ff1d9415ee802b351dd499523d0243f9a6159ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "596ffe55e3475b4880f717284271705022f8775c3e2dfd6a2748f36dcef7563f"
    sha256 cellar: :any_skip_relocation, catalina:       "09b1cf53a0637903e57486367b939bfb69ce941ac5081722cb890b9ccc269f46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1adbe041611bb5eeec95b358d314f88617c6080dc7bee0fba4ba2e28b81679dd"
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
