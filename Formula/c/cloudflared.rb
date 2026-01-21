class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2026.1.1.tar.gz"
  sha256 "9f10dc955023c4d471ffa1d202bda994094f073066d81ccb69ab7c27801f2fab"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b3d637549847ec3227fadb6b2e3daaa6e9836fb9c3e3c23d338e66ad4a14d4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92dc26e7c5b96822830371eb81207ae5dd673b548707862da797da74671e6f09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd5daec3282cb670999ecf1d0e25b05bea73b635cde116925d545a1edbe02c03"
    sha256 cellar: :any_skip_relocation, sonoma:        "0197cfeb5b7e3d64b97a30e1823ac5288afb4c0bae6705c6f6ab2b67131e87e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d4c46a9da02481f131497ada4a0c9bd08dbefe8aad6ba9cdedccba053363606"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f19985c285e8d1542f06eff8faad304cc07a9bccd25d4c4fd510147a219ff736"
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
