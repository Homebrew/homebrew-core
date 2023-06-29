class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2023.6.1.tar.gz"
  sha256 "7f7509bb364f107541dc810410b763721c39cdfab85799080ccae96d1c4a9cff"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99ad0191ab711dede574ea04def1059bcc3583c912bd830c9ae614af0903c83d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a22ad32dcf40616ef305bb7d603ed2187ffbd695caef05b42ed55869b7f9af71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8d29b0c85f5a57b46a272368684c506ab5a8edf3715ec85b7cf20d3abb97230"
    sha256 cellar: :any_skip_relocation, ventura:        "2186aceec0170c24af989d52bb27c6d2be47ff6387aec86d96e5080ee415269b"
    sha256 cellar: :any_skip_relocation, monterey:       "8c9edde7bbb6b5c2526eac7e72918958b5c10b0f37ac1f78afcbd6218a254e59"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed511fff148d5338df77d17de66aa9bd12ef8f7aef38e184b0ab57742bed1738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb39be5a109ba66bd40213480a0517e7f0350ca33a5b7f962dbfd64793549bf4"
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
