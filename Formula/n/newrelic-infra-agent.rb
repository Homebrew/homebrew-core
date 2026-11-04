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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9d4f5e47e7f6889f9c7d9e9ddc0188b732f20c5df6e0275ce5ac71e2967e4ee7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "57a6e91ffafbf5b4e0adc5571a4692d4c1dc6889171c5cdf482d759481b1ba06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2bcc4980e70795f9cb9b746c330a225aea883ed2b8b94d4902fc0d3c964f8576"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bb8e2e3a2cd2398842d3c2870e6f7bfcbfadf12559ed81152cb33dc75a79681f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6582c97dd63ad4505fa2d356ea22a5a53fab0697642e2cec14aa271d5b990b71"
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
