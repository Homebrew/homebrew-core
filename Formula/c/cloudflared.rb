class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2026.7.0.tar.gz"
  sha256 "f986f5b2a7309bfe21db8d694bdf09ae2904b0674c67744aa645038e15608383"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96572f4c15cac8e8f449a8749b3950503ca8f2a7beb58a435ff39df7f4b2f4cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1e239f6363e2d15f939565ef102209a3c126906f98af1c5fb0549c53de3cff2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b14e1d3133538b6d711f9e98a52163fa7c3525a8a28c59d5af8a2d58f6154c71"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1269302e6e82922c754805b0fc8ddfb28113e708f158890655db9e4367fca0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcb42988d8a28a1a40a232671cd0406bd58a50b0db855ee2490804b6f4380cdb"
    sha256 cellar: :any,                 x86_64_linux:  "d6fd0828b9de51fdf3fe6409ceb01201d935a91f4bd841bfde434add95ca04b2"
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
