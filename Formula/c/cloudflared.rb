class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2026.11.2.tar.gz"
  sha256 "e135894809a639d248f46636088ea8b659ed4d063be4873a541b2d9c2de36790"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    manifest_sha256 "0a7079f6a7bc261911cbc5699001084bfa6cd9a591548dbc71c0de0f739d9058"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ceed6574cff9c25763451e72dcc74f35dc1b92ec0d045474d56edc775bcd6fcc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d6377016018c06d34d81c26ec39a74b632b5a29f238a39b6a065773de02afa66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c4612aecd44544faa5dfabe73ebfa839fa0158782362b613fda1a8f085d9da9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "40243bca86d49e819ee2b32f6f36fd456d56f378f8b004156d83ba8fa8e97a16"
    sha256 cellar: :any,                 x86_64_linux:      "c81eb38417bbee0ed2266f12c3e42189e7295748d2146ed097a38625c7642295"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
