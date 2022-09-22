class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2022.9.1.tar.gz"
  sha256 "4919eef5814b4ecc41e1359f9546389688194c9e893b4de3c40b0e3cd2919605"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0beb40054e72e019c51b70875f35932d8315bad2024da9e7fa3c78aff5ea795a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f359321f64f73ab8494c1415cfc2d019527409b6b8d4a7487d7c5bf3d065761"
    sha256 cellar: :any_skip_relocation, monterey:       "92a0e845203e77d926dcf1769f8ca4ade66db4827bbe60b109b6e1cadf83507b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c53d6e6ab465e84d832885fb113ffd3e1f683d1787519bb608166d9e4d08815"
    sha256 cellar: :any_skip_relocation, catalina:       "e2ee070dfcbd812c416cf296dbecf675e9fa170fe1e5dacd15d74452fa51fcf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "146e98837a1b700372f86242a85bb676152923ce79d416e580bf7e7c918f9a6d"
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
