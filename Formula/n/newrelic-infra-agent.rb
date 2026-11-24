class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "2.1.3",
      revision: "8a6fe363cf5abbb7dd670b0b4514b863857467ae"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "c3d8324426b5afedb4fde6cc58e6948a6ac28a149a3c2a9c16f6745023665f66"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e4993e721d619a7cc8702ebf0cd29c3953e212008e03bcfebbb3b0c8af5cae70"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "848a8a2aa0d89adefde3b5452c62ca3c73352e76d0162e0a558d7c731d78a456"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0ea7f0d8a70b65fed7103782875cb11f585f24626ea8847f76d2b66eb78a8c5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3050d97a12aaea863c91bea32f20b51f2e35013477a1bae0959827fa9bbb92ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e9b64fbec81483dfffa41b3028dba83b03ed9e8282b0eeafbf9fffda2f78dbba"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    goarch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase
    ENV["VERSION"] = version.to_s
    ENV["GOOS"] = os
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ENV["GOARCH"] = goarch

    system "make", "dist-for-os"
    bin.install "dist/#{os}-newrelic-infra_#{os}_#{goarch}/newrelic-infra"
    bin.install "dist/#{os}-newrelic-infra-ctl_#{os}_#{goarch}/newrelic-infra-ctl"
    bin.install "dist/#{os}-newrelic-infra-service_#{os}_#{goarch}/newrelic-infra-service"
    (var/"db/newrelic-infra").install "assets/licence/LICENSE.macos.txt" if OS.mac?
    (etc/"newrelic-infra").mkpath
  end

  service do
    run [opt_bin/"newrelic-infra-service", "-config", etc/"newrelic-infra/newrelic-infra.yml"]
    log_path var/"log/newrelic-infra/newrelic-infra.log"
    error_log_path var/"log/newrelic-infra/newrelic-infra.stderr.log"
  end

  test do
    output = shell_output("#{bin}/newrelic-infra -validate")
    assert_match "config validation", output
  end
end
