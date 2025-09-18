class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.68.0",
      revision: "e863d09bf39bf333c0daedc9b3932f44e281a065"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47270a0e8b355a330459776602971060ca00c49dae760e3526d0d9c300a99800"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77e9c3dfb2c537289d8d7706ab8bf9fb5be86518ad91c17d8873ed010c7c0866"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baaa73f3b38d39435a2fbfb41bed4c8830d3d545eb096430e82f1d3c28cd64bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "433f1ea694a788bc56855e8617f849f397d00266fbfbfcf8660fa692aea616d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7512b66ac98c6ae6340c4aff32d4123191979262403b70d3127cc3382c8eae65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "384805e8d0fdca2dc065db14b2f8d3c29053717f77c8bbae43e266d582719d4e"
  end

  depends_on "go" => :build

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
  end

  def post_install
    (etc/"newrelic-infra").mkpath
    (var/"log/newrelic-infra").mkpath
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
