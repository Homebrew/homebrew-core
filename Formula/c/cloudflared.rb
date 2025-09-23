class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2025.8.1.tar.gz"
  sha256 "803d3e162dc91da6b3b4f7961f57c113fa818d45517758511f72d254d68a46ba"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "827d07d2ca3a792bf3967e57d9dfdb13e4109db9535aa7ed93401a6c8f5ae3f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7bdeeb4121bb1f2c53a8bba24df51ae40089d7074726311ed28f06125bf4822"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2d6e365dd1ec7d0887f74f26f37a4c8425131aaf718796946af1eb8fcffe1cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fadbadccbc819b855ccb7b60e2d20844eb040e71703074f2f09f251e684ac1c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b47709d6b02a98998d79995e5fd4fa3ece11a37cb83d0771e617abae7e1b354"
    sha256 cellar: :any_skip_relocation, ventura:       "6ce4268e9f23517ce28279334fc06496999bceb1cfad0db8cc8c9c316c693a4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf14be2e115acb01ec7d725a0b6e3db2015dd179ba2d7d03848358a24370a229"
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
