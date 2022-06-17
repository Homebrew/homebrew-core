class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2022.6.2.tar.gz"
  sha256 "599ea11ff7f6a8941eb2cdbc1eced0419eb3dec85104f3f7a6a8268f4d0e722a"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd0091c4e8563ff9be70858f90cade1bb65dc3317e811bee658d0178cf19496c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5ab9a0fad45b527ec389bd19cf597e467000fde0cbe6cafe5130c1015dc5706"
    sha256 cellar: :any_skip_relocation, monterey:       "d6f36720d1cc498399057731c203f2913244351932c2bab6e32cea668d9c5bcf"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f55790fadf10bf5e1901e9ea270986313a745c82650889006cc21a5c597fbdd"
    sha256 cellar: :any_skip_relocation, catalina:       "6f11d30807822828ec1add8134f99f258be165f1c48cf0b1315d8f8973f74069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee6aaf6fae655bc6b5d7a9909f108ba41ae733370b881daa425aac8bd56bde3e"
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
