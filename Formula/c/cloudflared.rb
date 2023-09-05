class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2023.8.2.tar.gz"
  sha256 "ffc3c07263b5a44121781d8b711e57d6414ef8de3da991849762df87618a27f8"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df7516aaa0bfdcdebd27ce777f2f394af638485757ffa8a891c954e0096354c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4084ec88a1c39b35112a0121d517068f655c76cfb9540c3ea8b77712027e955"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3c35499ec815358b5c174f56b0b178df6eef3d1cacbe1c30bfcad788ff7a8e8"
    sha256 cellar: :any_skip_relocation, ventura:        "9a63072e57797b7890da1c699423d46677d48f96ebc540d0f15d3bedfed1a0f3"
    sha256 cellar: :any_skip_relocation, monterey:       "3d0e9cd337f9a30854952b71e3380e27db70ab257377c6ed6150d00bd00a8a02"
    sha256 cellar: :any_skip_relocation, big_sur:        "f44a6efb2c2d3c35b417cb959d3ed132cadc16d39f4008ebc8783273e5271a6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff1c8479c4780e0fbb649ee247ed479f469d7059f6d9c84ec918ba21966f317e"
  end

  # upstream go1.21 support issue, https://github.com/cloudflare/cloudflared/issues/1054
  depends_on "go@1.20" => :build

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
