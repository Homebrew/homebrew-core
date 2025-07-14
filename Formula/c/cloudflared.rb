class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2025.7.0.tar.gz"
  sha256 "62210e924ff0c5241a0615e460456c2634499234a1f7f652912ce18320af05d7"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba076980f846985ddb8f2d7c55e115f321823e4b4bf9c0c191cfb8808104ebd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "099f55a98d58fe520ddec1fa339d6c8ade58106b69f2a97f40a982c6cbb8a203"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31b6f3bae8904e61097168791be5d7cb8c4923237ca6f5122de340a42dda262d"
    sha256 cellar: :any_skip_relocation, sonoma:        "841d578e94a18d0331ac3730916f01802e8062fbccfb81ff72aef312a956640b"
    sha256 cellar: :any_skip_relocation, ventura:       "49174bd3d7e19dc5a21eca2cf5ad965435007e8c8f5b991a6eb955419da9d722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "109d3cdd33dbfce354e5c21e2768f33fd697b4e8d5542c7c9f9b840ade2d6fb1"
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
