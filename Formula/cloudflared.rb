class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2022.3.4.tar.gz"
  sha256 "e810ccc855cc25e8a2f33b42d33570edf97856b227baf4ca0def8e47a4b8d387"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "737b9bd88b50a6ffe46a83d7afc2bc2a747c30dac72c6a372e390e1ab8330185"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "765d261b11cb13cc20da0113c596adfa02c4426ebe727ce8f151f7a657e05ead"
    sha256 cellar: :any_skip_relocation, monterey:       "c3b71f084594773441abd7aa85169c9ec61bb7cfd92acf5362be7c8936f78ed2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d44cf68ddc7fe6766ce143429c83dc8800df6b594aa83549b7afadcda6640c5f"
    sha256 cellar: :any_skip_relocation, catalina:       "06c1f4029ffa33a46cf89b6c928344bc5b50c22aefc168ad74fc8747129f68f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b9e33d4ccdd923e693c746875758754219cb13cb9008f9fe13abf285174c7a8"
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
