class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2025.5.0.tar.gz"
  sha256 "956e9cf01b5f3735a7f032eb1c7f1977345b4bca5997ce6c8fb7daf5f15d8fe8"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "974bf7430857d1dd6daaa5400c373cae875f464a9c2a9fb3e0608913fb0bbeec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4f60667540f577b82784c6a674ea8cbadb3a1629627fc019a7f075ba1042e0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cdf16454ecc2fcc285ec76f683c10e9fa0d62b45afee18d470b8771b4889e03b"
    sha256 cellar: :any_skip_relocation, sonoma:        "85b16789b560619f53fd2cffc5e20fea285ebd95f96b829b9aba7edba40e6ad6"
    sha256 cellar: :any_skip_relocation, ventura:       "a35bf2b0750e6278855a2b929959df8e1f5c09d007c1f1aff7e33955686a1feb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a67987f86336cdc31764f3b30fa46a54914e1db4c26acc022da5ca0c3c58f57"
  end

  depends_on "go" => :build

  def install
    # https://github.com/cloudflare/cloudflared/issues/1460
    # build with newer Go version to pick up the backported "-B gobuildid" flag
    inreplace ".teamcity/install-cloudflare-go.sh",
      "af19da5605ca11f85776ef7af3384a02a315a52b",
      "37bc41c6ff79507200a315b72834fce6ca427a7e"
    system "make", "install",
      "VERSION=#{version}",
      "DATE=#{time.iso8601}",
      "PACKAGE_MANAGER=#{tap.user}",
      "PREFIX=#{prefix}",
      "LDFLAGS=-ldflags='-B gobuildid -X \"main.Version=#{version}\" -X \"main.BuildTime=#{time.iso8601}\" -X \"github.com/cloudflare/cloudflared/cmd/cloudflared/updater.BuiltForPackageManager=#{tap.user}\"'"
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
