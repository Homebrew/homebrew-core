class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2026.6.1.tar.gz"
  sha256 "c3619a29cc529a5bc43ba99e1b298483ac0b8d8c412f69575c089a6bd4a7867d"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c912992963b9ed7a51e76c66eb484466071cda83f2899b3c3548330fe7bb64d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96799ce2388be581e3f825bc7fbb8b74c5b833e30086802c3b48b5a022356b1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c5e934d8982515416b38e72d8459585255e302638ec645b1dcff44d2db43f7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf86fee39081042b8d9b635bde75296aa0b6a3cbf33964c11782ff45a1dd4157"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6be21be0b7e4c06ba2870eaea19d8a36a2877f97e83d7010ddd326cb6f5ed6e7"
    sha256 cellar: :any,                 x86_64_linux:  "e5cf1b373200ec130a1a1e3ea7c7b805b6d293658e04799bbcac5276f0181c50"
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
