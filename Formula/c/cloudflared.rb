class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2026.5.2.tar.gz"
  sha256 "84a439b101b7fda1f5312640d5c2fe0cc37ae43e553e1ab2c71e3d0d9ce54b25"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "961295398533023d1bcfc3dd656d8e52f0cb740f631f8e0d13a71bf247ce6dca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd2c8cc51e2c8593cd50c9b80671248fb4039429473dd9a23342b7380f3d5df8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e1c7a205f4048d86d10b502224d70d8fe6539152d023bf03ef30da5529c3c53"
    sha256 cellar: :any_skip_relocation, sonoma:        "62bf5d32a47cec36d88f3a99344ecbeedbc740a6ba34db3f000d75f624fa36ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11d20c1c1315c5c407e087f87de7f50e9959e9ac723061e4b041bd602d5963ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "941519bb61c4bcb7040f07a805eabdefcf69e2a27d94fe676ddbc8daa870e367"
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
