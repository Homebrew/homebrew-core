class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2023.3.1.tar.gz"
  sha256 "cdd0f02fc4170842c8210db2b700bad88d8a7b5d00fb8f7336073737f11fc718"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2e9bd1dbbea83552ec1543025710a66699ae718970025fba731c5e3c4f3d58d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc01c718d301294dd224ae1573de505a3e6d21531aa56e4c1158902862083b4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "767462db4d5e90b6deac49b47f216a9b97275f6cec714367081fa4fbe19cf586"
    sha256 cellar: :any_skip_relocation, ventura:        "7c32008db18324ac26649987e34d8727e92ceada78742710e0ae41e017888cab"
    sha256 cellar: :any_skip_relocation, monterey:       "4b5d32fac397927931d50e03e9b957723e6a6e88ef2576d0266a12d4309058ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "6505b8cd678868b1d819f25f542b1584481de8d75e86f08b93c48ae9efc1ab80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb6e0092bde50d1c25723ce1e542b6e1636fae96a3e66f4434429e1ea384e6cc"
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
