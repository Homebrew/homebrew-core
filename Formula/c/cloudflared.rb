class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2025.11.1.tar.gz"
  sha256 "1a52c1d09e844f947736bb4215c9cdb411954f53c5c31aa420a2435dbe336714"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df776df3ab54ec3a29143ff458e7dfc56d9065b776f7a34a9d4d0c3176ad952b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2d97c72a34eaf3ab16defc8e748e8ebd150c32a354477710ab28a68b2a49c9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4b6d0dd56e35a79e4efee7da82eae2ebcb2f8deaf323da24448a9b74a06904a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d13c05352cfb75655d2078e806e93d32acb2aa312b47cc3b9db7e78dde0992c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1fbe5f35963ed5fe04e5697cba37e36f908e8f263f0f75ed0ae7651c4e8b802"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd297d0b612767b950f4b3524037f0592a5eff411ab66cf1ce5e62c99a6ea8e5"
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
