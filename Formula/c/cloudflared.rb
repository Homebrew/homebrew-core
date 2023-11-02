class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2023.10.0.tar.gz"
  sha256 "2d2df4dd4992eef485f7ffebc0a1e9e6292b42ca42341f2e46224f17155e9532"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00f8c3900e4857d9e8727f695aca057b918cad5884d363b71581f0da00e4e62a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e31a2b228cd0610f8ef4b57e7ca5a6b49dedd9f36a8d2983faeacc5992f8aad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b235910a8e8f362fb5eb9d1087269e5f7c7421e1859d4c48b8f6ce3be91d0be"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5e29ec84e676a2f26fd42554caee6ef52797251e1ddb164e6fd9ad28cbb7bc7"
    sha256 cellar: :any_skip_relocation, ventura:        "8335633179c63eeb7ad730d00c680349df13ab787dd17901bd05ada3c601d755"
    sha256 cellar: :any_skip_relocation, monterey:       "7bc6d505f625e847baba47f9f9620044dbad7da638fda1bba4485811d4e1c9fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34cefcae6d2986543b8a6ab1335d350af0956cb4ed659e202a74df5eeeb65b88"
  end

  # upstream go1.21 support issue, https://github.com/cloudflare/cloudflared/issues/1054
  depends_on "go@1.20" => :build

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
