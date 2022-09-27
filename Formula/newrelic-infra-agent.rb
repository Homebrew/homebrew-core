class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.30.0",
      revision: "6a23983066afc9e82058e4d0ff1c188491b4b109"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5622210f203ecf07f3819b9d6bf97354cd50bdae4328f67bafd3dba2b2935b2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a07c352f6a5aea2909fbb935be1e4eb954ff8672bbf3e536f7e2635e2d1b1086"
    sha256 cellar: :any_skip_relocation, monterey:       "7114f1128f5e4b3fcfa14b2aac969e3e5a3ea1f78306166bd95788a5df42290d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4799d41ae6f2245f48f420226280bbeedd0eb6cc1954cbe5530f113008dcc42b"
    sha256 cellar: :any_skip_relocation, catalina:       "8dc13322b51a01f6f21d4a0b16e8b5b91a71a940a240efa8cad6665faf5bb77a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13317cc0fcc57a38b7df1c54fdf76405ec6ae582b8ebf75325d178aeaa0aad87"
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
