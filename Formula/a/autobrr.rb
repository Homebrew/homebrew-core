class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.77.1.tar.gz"
  sha256 "e5a86891b10bdb7498916723a1587dd97e8cbda6c302d16514a1d0b10e976dec"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cddfe2f769d6c01e0848b97730886c2799b3f43525261349019d8b6e46c3ea1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bdf76a9eb60f2df7bf6f4df9396fad0ee1a21ecb7eccaa506b022bde75f5fe2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "785dea41e3b67a66cc5f5bbb045155ede381d715e4689b3ddc387dcdf67eb179"
    sha256 cellar: :any_skip_relocation, sonoma:        "d127f9a91a9d22d25a6d24384548b97fd0fec197738e815d1b054536302f5d87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2af95f3f2813678afed5e098641eab66ec53b6e769c9f4366d10cdddc8de0c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79556c1ea884b0d7a7b9382c1d1a243fd7fc3a56bb31df170fb96aead5f30ca9"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "install", "--dir", "web"
    system "pnpm", "--dir", "web", "run", "build"

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"

    system "go", "build", *std_go_args(output: bin/"autobrr", ldflags:), "./cmd/autobrr"
    system "go", "build", *std_go_args(output: bin/"autobrrctl", ldflags:), "./cmd/autobrrctl"

    (var/"autobrr").mkpath
  end

  service do
    run [opt_bin/"autobrr", "--config", var/"autobrr/"]
    keep_alive true
    log_path var/"log/autobrr.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/autobrrctl version")

    port = free_port

    (testpath/"config.toml").write <<~TOML
      host = "127.0.0.1"
      port = #{port}
      logLevel = "INFO"
      checkForUpdates = false
      sessionSecret = "secret-session-key"
    TOML

    pid = spawn bin/"autobrr", "--config", testpath/""
    begin
      sleep 4
      system "curl", "-s", "--fail", "http://127.0.0.1:#{port}/api/healthz/liveness"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
