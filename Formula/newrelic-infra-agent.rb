class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent/archive/refs/tags/1.20.0.tar.gz"
  sha256 "0ea19d1e70b7c9204bfe5aeb7803b4c3c6b0942036f8680ae52ae76d85e2fa68"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "ac813242b7d7adee1382611d5ff0b25bf12c98ead33fd5fda0474a143b79fa29"
    sha256 cellar: :any_skip_relocation, catalina:     "6f8b942d9f1b02383027bc790352b5bb24e8b500389555f05b7060cf820c3761"
    sha256 cellar: :any_skip_relocation, mojave:       "be96279cf0596779f75172306d88fd6bf8138d40051190c775bb805bdf811924"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dfc811b08b78f09bfca30f7cc64f8590854219ddd6461eabb8db4b61a9ea0941"
  end

  depends_on "go" => :build
  # https://github.com/newrelic/infrastructure-agent/issues/695
  depends_on arch: :x86_64

  def install
    goarch = Hardware::CPU.arm? ? "arm64" : "amd64"
    ENV["VERSION"] = version.to_s
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
