class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2025.9.1.tar.gz"
  sha256 "384283f05e55560e71d844991d3adbe7e2acaa278ce063b0c7efc84db8ec3849"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b4f95149382b0f06a7d11affc5d7bfa78dafb9be59e976e592338fc71ab715e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86fa5a859f5fe98c5355c41acf895d1c5e23b4c6d3767085014d8674233dc879"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cba71bf2d79ac8d7180d6b54aebd91575a8937d470988a88fc6bcd9da94c89c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1f8e46b1dd1d1777a6568fb7ba16949d1169f1c212f6aa86e96d3ba0c00a6ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e1af445134e042e654b5426e9eb8b54485e513c33b4b564d3ea798287b3438e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31601dc399ad3971ab637ae47ee71c740fc220e1c4bb70e770390ead615d20a0"
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
