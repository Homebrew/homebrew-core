class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2022.10.2.tar.gz"
  sha256 "a59ca80e75b09df628fc987a0278e24ca7fdc483ac18d2d579950e6fc8e91848"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d88a9df39b3d8fd77de69d980bfc1ccc7788b084ea2b6018858a7fe9de3a95b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa4f4b6ce45984b99e4589064f2b6e83c4127510e81f84e2a9d17477a3202dca"
    sha256 cellar: :any_skip_relocation, monterey:       "8f07ea56a046022c6d5cef8365afa57a1e7c9ca0287a03df4f7cf58708030bc1"
    sha256 cellar: :any_skip_relocation, big_sur:        "34b0c4aa529dd87776e9c1b6f6b20ea9b21760a49c428c12de87c1de51b06c3d"
    sha256 cellar: :any_skip_relocation, catalina:       "22e9153233fe9d1b65296c75d8a9dfd9ba9ba8e2adf250208747e4ef92ca7be3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0450a260bff6a4b3c6f72813d254e276576446418548ad41dd731fdb36dbef58"
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
