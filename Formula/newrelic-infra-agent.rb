class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.32.0",
      revision: "98a27d39e9a3282ffed2f9160ea651773814d7b9"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9b4e4ae610167e5ab7148aafc2f52bed8e043bcb891471d52ea8cd95fa21208"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f68e03d10ae3a482768bdb129c208f9cf7335820b50bcf8377add8049b3d673"
    sha256 cellar: :any_skip_relocation, monterey:       "0e25582de25e96fe7ba087db69e70f49c3416cc7adff440b9847985070b77537"
    sha256 cellar: :any_skip_relocation, big_sur:        "23653f77f03cee47f1abb773093620cfb1b3d8d089ee4e511568137a24320bd4"
    sha256 cellar: :any_skip_relocation, catalina:       "ba014af4d0bdcf4097a8daffe47bc78487c95a1d3c9bc18f681fe990d92d8f14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb898b7a4a86fb6f7c1bf7ac83cf0511e94b2e122f597ff6bdbb63d8a23bf371"
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
    run [bin/"newrelic-infra-service", "-config", etc/"newrelic-infra/newrelic-infra.yml"]
    log_path var/"log/newrelic-infra/newrelic-infra.log"
    error_log_path var/"log/newrelic-infra/newrelic-infra.stderr.log"
  end

  test do
    output = shell_output("#{bin}/newrelic-infra -validate")
    assert_match "config validation", output
  end
end
