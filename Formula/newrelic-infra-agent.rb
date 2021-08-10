class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent/archive/refs/tags/1.20.3.tar.gz"
  sha256 "3a29b19541e6f32fb87196a7833d08a9aed41b8ff62ef3a72326236d262cb033"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git"

  depends_on "go" => :build
  depends_on arch: :x86_64

  def install
    goarch = Hardware::CPU.arm? ? "arm64" : "amd64"
    ENV["VERSION"] = "1.20.3"
    os = "darwin"
    ENV["CGO_ENABLED"] = "1"
    on_linux do
      os = "linux"
      ENV["CGO_ENABLED"] = "0"
    end
    ENV["GOOS"] = os
    system "make", "dist-for-os"
    bin.install "dist/#{os}-newrelic-infra_#{os}_#{goarch}/newrelic-infra"
    bin.install "dist/#{os}-newrelic-infra-ctl_#{os}_#{goarch}/newrelic-infra-ctl"
    bin.install "dist/#{os}-newrelic-infra-service_#{os}_#{goarch}/newrelic-infra-service"
    on_macos do
      (var/"db/newrelic-infra").install "assets/licence/LICENSE.macos.txt"
    end
  end

  def post_install
    (etc/"newrelic-infra").mkpath
    (var/"log/newrelic-infra").mkpath
  end

  service do
    run [bin/"newrelic-infra-service", "-config", etc/"newrelic-infra/newrelic-infra.yml"]
    log_path var/"log/newrelic-infra/newrelic-infra.log"
    error_log_path var/"log/newrelic-infra/newrelic-infra.stderr.log"
  end

  test do
    output = shell_output("#{bin}/newrelic-infra -validate")
    assert_match "config validation", output
  end
end
