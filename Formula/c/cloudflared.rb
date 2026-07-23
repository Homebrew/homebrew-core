class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2026.7.3.tar.gz"
  sha256 "8e452b1630064f5951e18a2537e66274e006eb2e83daa0d42a0adb3fab3ee788"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52530bb76939ea3f5db4b7ef26c9fa9b7499ea7df7b7f5716eae143d25979de1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c982b67b686c3af60261c9633466de1ff551d5891cf8724232e3e0c1ab542634"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74152a76877e0fe67bfb892c6ef44b34e6b349358cac06e02255267ea6bb824d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f274c3aec0e6beaf589d2c07514eec27cbe7510b259a83987be1823fb0c9394"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e5929ad339aaaebbddc3803c09b9b922a7e60a2996580215d67e49eeb619477"
    sha256 cellar: :any,                 x86_64_linux:  "bd7aa5f619b16ae90a57b68f07bc387343daa87a1195ef5ffe9cbfc08bd88dd9"
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
