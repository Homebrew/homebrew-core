class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2026.8.2.tar.gz"
  sha256 "acdf125b7e872be6e1d13116e8054d27b2c4755760b0cdc3b4ee3910edd37b93"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c90470f8591f3d25fcce1040dfb9cd08085af69d05cc5a012c60cc34a005f926"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0344bb7656f4ccc003ec2e99cac9462beec40ee53c03cfb07afd594b551eb9ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e77be1a6f66ea82fa82740c7cb15aeecd15daf56d777d2ea9137b0746a0bab0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac1c4a568839aaf958ec6b6bbe6696cbb9b69a3b119978c038951d86944d2e03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23ea8533ef8f04b21a83f67310aa27172f96d50d3d3ce7f2f1b8d8847702b263"
    sha256 cellar: :any,                 x86_64_linux:  "432b1aa4ea267a9a3e80c8a3528f29733862631ccfb7ff05d0e4d6d8f6b70810"
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
