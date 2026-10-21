class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2026.10.2.tar.gz"
  sha256 "8dde1e9e4b0ad5ae09abd7b5790dabc9195ba48a5c7f0af7e54e787eef54a3cb"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cd5d369f7745cebc1fbb4d9c309351b6641a8d44448bdffc867e209fc0303d80"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "66aab461d8af344f93f2464c1118f9c3d9b2710329b481dd63c57af7799f3692"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0947dd4e3a0e501d04e1b2ecc84ac0ad180a20287d5cc9284822a549f07a64ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e6deee348b7bdce0df251b3173e4e13070e49ad3babb939e882521b9709169b9"
    sha256 cellar: :any,                 x86_64_linux:      "a5ed1afb243ba8dcd76f2ccd8d83d385e9b9469ad41ee97ad784d36eb5b88fa4"
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
