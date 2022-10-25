class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.33.0",
      revision: "957e19b78c065a37d42667a06c8ad4508aff86c4"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48c5dc33869162173f8b51c4ccab7301077cb40d0fa03b20d6688bef47ee0ac4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "850b0af70f89555f7cc042c5398aa3fad3bba8faa5eb4170504df2ffaa09ce5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d05a72c7b3592ec87373512b5547d6728c7cf45c9268e2a0e37149246da7eef4"
    sha256 cellar: :any_skip_relocation, monterey:       "919ccc906ad16fa34c712458fbeb3a264d239b63d6f493e5ce29619e9b93742b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea4e8142f34f17d85347ec2870b796829ddbfabd2e78683a49580e2807714669"
    sha256 cellar: :any_skip_relocation, catalina:       "9eeb2c3ba54b5da06b86f9ea74b1821382fc242d9b5c7d1e6b5cfdcfa702549d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5863a421efbd6fd5f8c2e2fa7d00b158524c4cdb20f0476bdc9a6e3e59d8a58e"
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
