class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.45.0",
      revision: "1cfd539a4796a48638fcb243bc8a713847b1fc6f"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d9a3a57caa4303d76400585c826682f9a6de618fc361c3facd2198a158e40de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fcadf3639ffe69f4ee362ea05a516026673a23ff26d1aff7ca130fe74014ee2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8cada90d54b4119c40909f75feca4293e768f6e40b928b876ba9ad84163bb534"
    sha256 cellar: :any_skip_relocation, ventura:        "e3515887826b85f2fa7e79d4de497f988bb3108169825ba014664ed4c13dbb52"
    sha256 cellar: :any_skip_relocation, monterey:       "17dca9a3a760486db59d9ae28c46edeea0642a64d3291bf0e0e0e4c4b59457ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "45abc7efcb4eb5512e3b2c5956bb386ea3f1bf6f86c5da5086b378120628fb4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f07c1b288074fc120c2da65730e8d41c32fd478e741e8c808213b34e32e3791"
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
