class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2026.2.0.tar.gz"
  sha256 "31f57e9528413e3ca33c3b99343e4304ab3b5eec4becc3fc436e4d58062899d9"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a3460d94744b69b4d5c5554e58704260ab04dd2afb8f6e1bc0a9f20f302aadf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e3e92e89f9a6d440bb317b2efac053983cf1c7eb5e29e9cc430915e076778ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be3aff7c01c4da66a402e347bbe90c0cf5a48eb64023b0d12ddaa3bedc7f563a"
    sha256 cellar: :any_skip_relocation, sonoma:        "67f7cd6b3d0cfbb7c7a425c28eb30647e11149435c92e75fe7a973ac0a5db792"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3ff8f088a710317c564b63d88310041c5706e028bea36216eb6d2f9cec0afd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a44034f0f0c06ce48431f83947ad30182a81fa5ad943eb0c74d821697bf33209"
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
