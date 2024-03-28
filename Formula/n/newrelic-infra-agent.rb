class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.51.0",
      revision: "ba5bbe5fab336fb15e326dd6d5328b253d9d140a"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6bf335038ba720b3c400f54ac57b6ff6d893dd29f33e235813b08114a4ea79c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9991b012b0e9328566d386176a1829da39e9812abc86c0beec9b7ff7fe6560a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae5413c45e01706bdf04488998928c15211b5d25ebdf9ef97b49d898503ce7f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "2516f7fceefe63aab576b59481e639979ccec414dfacc961f61b78278f4438df"
    sha256 cellar: :any_skip_relocation, ventura:        "e95e5c19b79fbb1bbdbbbb5e03c6ad9e042ab640bfa382c621bb53bb61541b6d"
    sha256 cellar: :any_skip_relocation, monterey:       "1dd773d0010e817dcc4b59e90c399d409d2d6422f7a6e5dd457b9a1c634b2268"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e79d9c3e01f2658ba16be94494c9b0701c327c76c215d20832038c7ed60eeb2"
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
