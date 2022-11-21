class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2022.11.0.tar.gz"
  sha256 "01478108dc4a4a74b2a9eecda35b1b7cc69ce33f45fe0c94edf598b90154fda0"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98c31a1d3d1e439d9ca1a16549b79a19c473c159bd56794b89c53bd35e493ec2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f0fb04f6db7d43e50516b5f928d4935e14738543fc42bf647ff68a3e8176079"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e74383af1d7dada5f4a13451d646e4c8ee26cb8d8e7e690f94d48fc696697de"
    sha256 cellar: :any_skip_relocation, monterey:       "e77faccf06d030b9dfda8cbe0a0622210f9db5e0fb296f33e62c1d1de5dd7b1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ae742afbe2057465caebe3601fe59d1a46e5b2e451ad243a84eac448b4d95c2"
    sha256 cellar: :any_skip_relocation, catalina:       "aac955941d69ea4f61df3bd43bf280e07e63fe6cd3e218f79d2a346760429b65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c47dcfba7f42db7051e224816a6889a480da9ddee7cf5545686e8a2afae7d93"
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
