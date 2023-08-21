class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2023.7.3.tar.gz"
  sha256 "772ddcb721f5b479192117d1156b1091505721aa81d6bab3de9577176b930191"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "706f26cb5cddb8ed4b69e121d5cb8113f02683aa21b5c6ddc222a31dc91a1d90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c5417a2a62abad137ed6817449aa3fba7ed7cae3162f00da9be37433253faf3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22002664d93bbfda7edf89eefc8483128ffacd044a28400134d748246692a163"
    sha256 cellar: :any_skip_relocation, ventura:        "0fa688dd9e325c8f053bf9c0c925f8fa1ee55fb652d0440c2e42bfc5f8ef45d9"
    sha256 cellar: :any_skip_relocation, monterey:       "8909d5bdd5de93839c0f38213caae1622e9fb55a317ad81506f1a5c192b275ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd867b4c1f3d255eaaf5aed2937cdf9d038c614b7bcb234bbb8b7d028549fdd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a7cf25bbb6d92b0b3f98ca5df20badd95f6f7997651b5c26256cd527422ca0d"
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
