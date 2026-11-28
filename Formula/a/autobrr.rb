class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.91.1.tar.gz"
  sha256 "336a300b521ec59869047680032d0af5f3c42d56264fa82a3670e1bf3cb3c3d3"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    manifest_sha256 "1abe28456c87ba85d5c468e886c1e1491234721a69632cc9133c5138b8734160"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "be341d9a763ebc92541708af7382c7e51d64512ba09544698f2e6381c800fcdc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c401068c2647c8e922f6d4d4c0fada9eee1e304803d59369fa775da26ff71b9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1381280dab46b36d9381c887052108cc304c2b4075765ace4d082e503253dbeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "345271b210f0a22d0a9e8adb14171fac1a055ab91c50c6cdefeaaf44546e6498"
    sha256 cellar: :any,                 x86_64_linux:      "7e85c9877d94d0373da0ff4021a59a11adae22ab23fa332005f9e9bdbde2dd06"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  allow_network_access! :test

  def fetch
    system "pnpm", "with", "current", "--dir", "web", "fetch"
    system "go", "mod", "download"
  end

  def install
    system "pnpm", "--offline", "with", "current", "--dir", "web", "install", "--frozen-lockfile"
    system "pnpm", "with", "current", "--dir", "web", "run", "build"

    system "go", "build", *std_go_args(output: bin/"autobrr", ldflags: :goreleaser), "./cmd/autobrr"
    system "go", "build", *std_go_args(output: bin/"autobrrctl", ldflags: :goreleaser), "./cmd/autobrrctl"

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

    with_test_process(bin/"autobrr", "--config", testpath/"") do
      sleep 4
      system "curl", "-s", "--fail", "http://127.0.0.1:#{port}/api/healthz/liveness"
    end
  end
end
