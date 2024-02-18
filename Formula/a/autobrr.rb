class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.38.1.tar.gz"
  sha256 "b04e477c6632023530f106365757e5d0954a19e3a0025cc66a4a41815e0e942c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7897f1dcdd7a36565676e4ba4981f0cc1e236e733d0ec37cce00fe6f031ee48"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcbf2729754d7d26d2d4883a9c65d6f3467eafcfa0a55aa1b43f922118fd6f4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1be9a9b4805d06663572ed8d2bc27f3b836861d4d6bc8dad4ae425728ac1c38b"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4b6120e1b96d2aa0546c8fbd9fe3a2a18b16fe3d63681d2e9f8f33c1eec91f6"
    sha256 cellar: :any_skip_relocation, ventura:        "b8367762892738f6fb7c5087d7ac10965a5457a807ba426dcf115c312504fe74"
    sha256 cellar: :any_skip_relocation, monterey:       "8bd282b1811a7387165098fafc6321786db7fa7ec3ececb5408c4cc661b5800c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bde718bd1a49a0c168810bc2b222b5e4b0a717b33ce28d1aead3a59142779de2"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npx", "pnpm", "install", "--dir", "web"
    system "npx", "pnpm", "--dir", "web", "run", "build"

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"

    system "go", "build", *std_go_args(output: bin/"autobrr", ldflags: ldflags), "./cmd/autobrr"
    system "go", "build", *std_go_args(output: bin/"autobrrctl", ldflags: ldflags), "./cmd/autobrrctl"
  end

  def post_install
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

    (testpath/"config.toml").write <<~EOS
      host = "127.0.0.1"
      port = #{port}
      logLevel = "INFO"
      checkForUpdates = false
      sessionSecret = "secret-session-key"
    EOS

    pid = fork do
      exec "#{bin}/autobrr", "--config", "#{testpath}/"
    end
    sleep 4

    begin
      system "curl", "-s", "--fail", "http://127.0.0.1:#{port}/api/healthz/liveness"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
