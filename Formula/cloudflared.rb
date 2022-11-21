class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2022.11.0.tar.gz"
  sha256 "01478108dc4a4a74b2a9eecda35b1b7cc69ce33f45fe0c94edf598b90154fda0"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bae83cd671361a31b08ff0ee753258ad8ba9455ead89a30a1bc5263d60b97d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ce2a757b7c500c26957e4707fa87186842f74b8fd6ac3f757f43ab6f9063909"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83b5288a1d40662a08d1fccf5f26e1917bb6dfdc422b86d99c36ff5810ff316d"
    sha256 cellar: :any_skip_relocation, ventura:        "d8344ba7fb881d4ad052d0e25b2ea6abf7935ddb53f248e57eb90918fb60cde7"
    sha256 cellar: :any_skip_relocation, monterey:       "a5dcd4861962c17610e8de381d9c85a86517135a0fc1caf016faaba6a766d9cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "26ce0a785b8a44860ba141af43c493692291ce9dba05658ff9f692cb336f6fe7"
    sha256 cellar: :any_skip_relocation, catalina:       "2eb04768cfa2671acaa739dd5c4b472e44f618cf98d00b50f2f0b8facf4bca24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50e34d5c93e0aded5ffec0c1489549e5d569263487563b35b1782d0c20432d3c"
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
