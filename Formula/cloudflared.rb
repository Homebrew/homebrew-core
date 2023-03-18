class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2023.3.1.tar.gz"
  sha256 "cdd0f02fc4170842c8210db2b700bad88d8a7b5d00fb8f7336073737f11fc718"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f03a1947b83bbca6dda8942061bc90eb90bea2bf8356a7e4e6b30b69bc14dc9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5df49d126220c8fe7c1a5a4aed94cc93c38c9f64c38a45288b958f2d56938b8f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f87bb9cd0d15c254e7cc9174a4276f8e78eee6849af4264151ae7e92d41c64b6"
    sha256 cellar: :any_skip_relocation, ventura:        "c61d0cb380888a1a4bdeaf2f77bba693a33be84e521b553c69a41f76e338c4aa"
    sha256 cellar: :any_skip_relocation, monterey:       "a19993e254b5b1bd2606a2c6cd9c099b4fd13ba3202d4c3c78eb81fc5fe2f443"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb4597f6a504c1b842c40f9e89e4a966c7fa7c076883e8aeff4ed4f36900450f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dddc13a6a0e7496ce513d35c08e477ef2d14675b353b345d25b81bbb2d4e3085"
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
