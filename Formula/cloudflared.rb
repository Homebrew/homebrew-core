class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2022.4.1.tar.gz"
  sha256 "2e837dbe6f73d4ca60bc0ce56cba0f3c868b8d6f139bd8c06301b996d8e803ad"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ff59002f345e3017b811cf89862fc5939580fc50d3cb16893aee3054b730168"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "704ce96901868870e3eb641de3c616ba74ce05000d442303de242cf63f03418e"
    sha256 cellar: :any_skip_relocation, monterey:       "94ae4618c971c94f505e5fd100570e15439072da46d9ae374835f7bc8e01a31f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8831b35bae366b5c91dff7e8899cbf2efc2b94d3b2faabff8d03fe690fb475f3"
    sha256 cellar: :any_skip_relocation, catalina:       "239355aa6f547371cc2996eeb72dee44cb0676b184c43e6e0b1e43ca4f08782f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84224552978efa0344d0ebff89a9415ba06285cf13e4f3ae1f762ea059cf2d8c"
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
