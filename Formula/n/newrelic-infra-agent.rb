class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.49.1",
      revision: "d05f4eb2c15998b480f67e6c074eb647e5398d08"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d06736c695afe364f6bf1875ed0c5e71a7d3b048e7df0e1d0555c41910d49fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33823c10ac2ea57e4fd318b14f162d0b85274520995c0360f3073d5204481321"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f7858698a1f5e8043bf3667321a721d1596604bf1208067cdf083acc0a23d36"
    sha256 cellar: :any_skip_relocation, sonoma:         "0fbd1e7c3ea91ef080e61ca162f297c7417b10ee0b0e5819cf2ce216b33c7132"
    sha256 cellar: :any_skip_relocation, ventura:        "90eff650b2e75a6cb2a56d6b06ea60b2c31f87cf33efa14182478380d9658774"
    sha256 cellar: :any_skip_relocation, monterey:       "38a8a7273c21f01c6790dbf9cbece9e6927b7ee6574c2b50ed9c3c70c9ced376"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "836fc573a0b821a609b0b8d9cf90617cdbece1ca643eb0448c5bf4c6e7d80051"
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
