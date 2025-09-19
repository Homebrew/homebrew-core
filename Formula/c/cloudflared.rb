class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2025.9.0.tar.gz"
  sha256 "350d8d37a85355a34d3b48dcfde40497833c08233e49f5bed8cb4b690949552f"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf2610c701929c4f1ccf3f03b79613398ec4151cc57bb179d65ec7d61cfed395"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ca3d67b51887aa4462f545830784b0f4573d7fa1bebeb1fcbed8ed7957b2618"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27135e36f6c2d1caafb6e7375b1dfd8f549d71b981fdfd01a503e859edd8c213"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9549c54a0b5cb915c4ad57dff7d545fbc04b6ae4ae434e7081295365f004c9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60c624e8c060ca4d5c9ccb5285654dc35ce0f04e84b40b8fdb5286113203a842"
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
