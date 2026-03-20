class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2026.3.0.tar.gz"
  sha256 "1c9e88653f091d3085975e50c2cf7308923c88ed5c82afe7fb98938d3f9c93ad"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cb336ccaf454d27557653369b8f65d6596554426c548c333b67eaa13d3de84f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e699e553d80da8370204a55d8d9494f3a14f26d58764bb522ea3154c7a46395"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "350363f511b7a25e8d92793d8e92b56d068b2e1e86b4bc77074ea1221d0c78ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "98b6c314d4974d9093fc5a5923109fa413b584183c3fa03d7f8ef5fc9aa07940"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac1972bc807cbb684bfc0bd61396b418968f26aec92a65f3ed71e3a37b6a132a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b782a604e9d604359e50cb4629b07e4e90f22b3cbc25ac928cdf1dc2c7168c2"
  end

  depends_on "go" => :build

  def install
    # We avoid using the `Makefile` to ensure usage of our own `go` toolchain.
    # Set `gobuildid` to create an LC_UUID load command.
    # This is needed to grant user permissions for local network access.
    ldflags = %W[
      -B gobuildid
      -X main.Version=#{version}
      -X main.BuildTime=#{time.iso8601}
      -X github.com/cloudflare/cloudflared/cmd/cloudflared/updater.BuiltForPackageManager=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cloudflared"
    inreplace "cloudflared_man_template" do |s|
      s.gsub! "${DATE}", time.iso8601
      s.gsub! "${VERSION}", version.to_s
    end
    man1.install "cloudflared_man_template" => "cloudflared.1"
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

    return unless OS.mac?

    refute_empty shell_output("dwarfdump --uuid #{bin}/cloudflared").chomp
  end
end
