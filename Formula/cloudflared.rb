class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2022.6.3.tar.gz"
  sha256 "74fb20e78f69db086f6044eae9d7a09bb3b59001a14d17c18edd9cb4ee8db4f6"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8e47f35ab9def833f271e926a0c1a55cde067a447dd1db481ccfe29be13321f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31f9a5cbd109f490ee5dce733c1139c0e490a753c031f6b5885a78c27e0eaae3"
    sha256 cellar: :any_skip_relocation, monterey:       "dc2b599c99ec240dfba3a8902d1da146b24e20a3e95151d2256d18d32f2dfcd6"
    sha256 cellar: :any_skip_relocation, big_sur:        "0059bcaf8c293762cc937d4d7f17409b37f013e5a1692e9f36517aa6180a32ce"
    sha256 cellar: :any_skip_relocation, catalina:       "6f620daa387daf4099ee5c8feab68e55131987386df536f0d8e54c643a7c5634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18230402076fed26521d567616e95c87620a64e47e349d79a3ab5e5b4d236c98"
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
