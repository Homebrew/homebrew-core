class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2024.8.2.tar.gz"
  sha256 "a6fe4be772ebf78f3a4ee615410e70f1aa95dafa1c173509d08fdd2f94bda3a8"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4a75449dab2bd16f0f5c3c6566bec0dc42f7952bb30551e6220ab484d72c757"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70e33006399042b983e3e5d20e9b44a4ca6143b59f90ce3b7d489b118af13809"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "196b63bfd517196af233d43afbb7f748d6b7b46defdbdbd2e868f0045f6bd9ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c585ca2dc49611bd6df053eccef9354b4f30473870a940a67e2191d096130af"
    sha256 cellar: :any_skip_relocation, ventura:        "5e17e02b7a06fac12af3e2c764f360ad0024ee7e822dfea58941103de3160ceb"
    sha256 cellar: :any_skip_relocation, monterey:       "f820268ba3f7f329b1eb04ba5a013aa22712a16f51943075e85dc2cc5deab78f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "867ba0aa70800bcd8d9435bafef2de43caa76c13f9dcb0fa23174aa8f8badfd6"
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
