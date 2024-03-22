class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2024.3.0.tar.gz"
  sha256 "6e5fda072d81b2d40208a0d244b44aaf607f26709711e157e23f44f812594e93"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0d0862a297c1056a5317b75e3d5495120e92a69871087ce47f4b03263556e58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef5d17363567875476ab8c6e05ff0e0d6c9b80399ba9e834e98b5d56490f5fa1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbdc50ac27339ffc87354bfddfd63d41fd88e629b344534faab429c6603f7c74"
    sha256 cellar: :any_skip_relocation, sonoma:         "49765626b2f75277a397d43022212ff2f24edf28a6527c16035fad04e366fce1"
    sha256 cellar: :any_skip_relocation, ventura:        "5db02fb6012d30097c2077a6e5226c1d5baf994d74441471b8a113410e997fb3"
    sha256 cellar: :any_skip_relocation, monterey:       "f61a0988335e3d00389df931d5666c89ffc1cbb285980e9174f798c9932abe67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22662b59402b9f31b40f81a98ae17b20e6e6a0fb5b2de0354a29f0c62cfd472c"
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
