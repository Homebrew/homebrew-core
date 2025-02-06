class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2025.2.0.tar.gz"
  sha256 "54de1e3bfb3ebcddd8bdc70837b6e91cdd2221673117356c022d0ca3376dcca4"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1977f8dcc5045209ebff1903112261dcc49df7c46752314f7018648a8f992f4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20e1ea590824bf692aa2bf7ff4e5c4c2526ed1468d4a8b66bdb39dc7ef6112c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b413a116243f4f795a96bc2015da82d96d22de8470d2e6ea52e078ee2bc53e1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "42a941c440ee29386b3860eaca8d3c2c84f9c61e5602e7dffd4dfec074af3f24"
    sha256 cellar: :any_skip_relocation, ventura:       "4f85d2aefe77519902fb520d4d0eb3760e9011fcde7ceccf9a818af6221e9638"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "940cca76e53adbf76c422bc7e8bf0dd241764f2eda4dd20f9c24cf5ff67f1876"
  end

  depends_on "go" => :build

  def install
    system "make", "install",
      "VERSION=#{version}",
      "DATE=#{time.iso8601}",
      "PACKAGE_MANAGER=#{tap.user}",
      "PREFIX=#{prefix}"
  end

  service do
    run [opt_bin/"cloudflared"]
    keep_alive successful_exit: false
    log_path var/"log/cloudflared.log"
    error_log_path var/"log/cloudflared.log"
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
