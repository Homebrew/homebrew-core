class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent/archive/refs/tags/1.20.1.tar.gz"
  sha256 "86401cb6ae785e45d6ed78f01cc67f48216a71fb90eec548164d6d22119850e2"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git"

  depends_on "go" => :build

  def install
    goarch = Hardware::CPU.arm? ? "arm64" : "amd64"
    ENV["VERSION"] = "1.20.1"
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = goarch
    ENV["CGO_ENABLED"] = "1"
    system "make", "dist-for-os"
    on_macos do
      bin.install "dist/darwin-newrelic-infra_darwin_#{goarch}/newrelic-infra"
      bin.install "dist/darwin-newrelic-infra-ctl_darwin_#{goarch}/newrelic-infra-ctl"
      bin.install "dist/darwin-newrelic-infra-service_darwin_#{goarch}/newrelic-infra-service"
    end

    (etc/"newrelic-infra").mkpath
    (var/"log/newrelic-infra").mkpath
    (var/"db/newrelic-infra").mkpath

    (var/"db/newrelic-infra").install "assets/licence/LICENSE.macos.txt"
  end

  service do
    run [bin/"newrelic-infra-service", "-config", etc/"newrelic-infra/newrelic-infra.yml"]
    log_path var/"log/newrelic-infra/newrelic-infra.log"
    error_log_path var/"log/newrelic-infra/newrelic-infra.stderr.log"
  end

  test do
    output = shell_output("#{bin}/newrelic-infra -validate")
    assert_match(/config\ validation/, output)
  end
end
