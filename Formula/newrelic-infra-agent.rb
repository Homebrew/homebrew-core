class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.42.5",
      revision: "64d3e890afb41246564b0b0dea93c3cb3ac41a1e"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a08386096a203bb4be639db3f31bd4c53fd479f4ad0e3dca028b0ed64cb183d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5aa7ec3c9e1a1d20d1274dc43a780918bdce15428ba7f933b87ad4e2da3b39ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3553c19542d5ee2f528c2c3ccfbfcd4e141e7d534259e97b34320d3412d12c98"
    sha256 cellar: :any_skip_relocation, ventura:        "b627ca993e4a796e405a7415a579b997a51822ef9d6550c93cefec7dd7832035"
    sha256 cellar: :any_skip_relocation, monterey:       "e4d7cf6fc3b28c7a4c4db867006238aada527548f6e8b558eee879e0ec5d82ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "c665c4504efecc30d52028a6bea92d366866f72b15ca44eae057872f47d9d3d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6aba0c1b7413ae38bda3886b95bd6e6fc42a730db936df31a141b10789bed1d6"
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
