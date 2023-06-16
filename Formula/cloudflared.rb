class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2023.6.0.tar.gz"
  sha256 "8be9ab929fa5bbc021041e4fe33e2f91b4fe16d9c8354bfc19b1ad3fedb39b51"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b3acb39f00f8d0da17740ea6bac37cc9f88f6d9e81bc38dc9bbc6ffb4426844"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7264510f9526c12438ea0c12f8fd26e5f481e36b580469276ceccbecf81bfe7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e467027901617e8ba9790a201de8aa59b3b740e1afdb20d57e3cc3cb2fa02a9"
    sha256 cellar: :any_skip_relocation, ventura:        "518e541e5f71cc57a6d05b8db1b2ffb32f732b20be96f1ba267ef1b70180c909"
    sha256 cellar: :any_skip_relocation, monterey:       "ed328dbde99b6ebee70366b49ef8efc3e9b2c51259a34af1d108532e48c412eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "34c9de5988d7681a82589d9d0ba0c7ff037b29b6240eca01300cb88c99b682f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec6484a768226a77b020b9d0f78b121dfdea6c37b957189c02454f382725ba96"
  end

  # https://github.com/cloudflare/cloudflared/issues/888
  depends_on "go@1.19" => :build

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
