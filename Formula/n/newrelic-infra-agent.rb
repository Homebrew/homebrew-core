class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "2.0.1",
      revision: "6da860ddecfdad62c72133a22754ccca5e14e952"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4e886ad78746dd0286343e94f6653af1c8e31f703afab73ebba9bcfa17f15a07"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5fae880a80f7db0f491ce4c0f3695efc02a7bbb54774e67ba929fbb417931ecb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e06b62ba113d8b20691eaa49022d95c3c4ca61d6032e9014f4cb8fa89f8529cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4de96d88a81d9de3056c143a8e5c450a9450413cb3d983fb540d6ee9ac0ac2a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "10cc5e60150bfa74664239fb1abc48378b64ea03c6560b733025c027b3cde834"
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
