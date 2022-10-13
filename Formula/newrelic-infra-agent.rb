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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2f9665383c0ecb549d311e7568633b50cee85ca9fec9e18bb13876dfe7fa586"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f8c44a554aea4a85a63c5d5bb1923a3197b04d17966c381e03f4824f359969c"
    sha256 cellar: :any_skip_relocation, monterey:       "c7e6d00ea5b761127cf65fbfc053517a9ea2993f3ebe2d85ab50c49cc16b9818"
    sha256 cellar: :any_skip_relocation, big_sur:        "c62f6d8cf89bc5b2b2fa9bbf71c91d3fb4afe14d5323cd0eaae84e30d2e1cda1"
    sha256 cellar: :any_skip_relocation, catalina:       "a6b20169f7b644dba3330cec3726a480c30b44ea650f39a968c15c6a873ec267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c3dc4fb5ec42f3a4d8fc4b5ab241fe0ba29028c977db9184bea8968cd75d4d1"
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
