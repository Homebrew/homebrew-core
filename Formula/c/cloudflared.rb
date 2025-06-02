class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2025.5.0.tar.gz"
  sha256 "956e9cf01b5f3735a7f032eb1c7f1977345b4bca5997ce6c8fb7daf5f15d8fe8"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f986e1933b0bfedcda124d3804e82d7cdbbb9aa86f1af5638a0dca5ccd8a6674"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f986e1933b0bfedcda124d3804e82d7cdbbb9aa86f1af5638a0dca5ccd8a6674"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f986e1933b0bfedcda124d3804e82d7cdbbb9aa86f1af5638a0dca5ccd8a6674"
    sha256 cellar: :any_skip_relocation, sonoma:        "517dd3c23052b803267f932b7a87bc95be77253fb8475b19951887a7cc3efcdc"
    sha256 cellar: :any_skip_relocation, ventura:       "517dd3c23052b803267f932b7a87bc95be77253fb8475b19951887a7cc3efcdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f68d56eccd8dd389f378ce4b71b323fa046240d0fa450c354ba2fe2bf10710dc"
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
