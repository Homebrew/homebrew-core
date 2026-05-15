class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2026.5.0.tar.gz"
  sha256 "21d57fc7da8d83ba9633f79f7593f5898a027f8410fecf5a8c33661090aa7063"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a27a6819f37f0ae763838b24ec40853c90a0d2d6e1a0229fe293b6fcd1582c8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfe28e5b147dd6af1d45c0eb55ef9da90ffff2148043a8f3e081f9180dc7659d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e4c018af8a83e94fc3c9736f670768ac55af718d9e6ed0ab342550defc48071"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ce9403ebd962c7b986a4ac4b4b49cb2226265ec21c0dc4026acafea55c6baaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ac25644fed4a5006791435b799a60370fef6367e8185400780db065e1c4153d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "154f69e263b13e81738363f14a7417fb7916030fcec8d3705b22021af509651e"
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
