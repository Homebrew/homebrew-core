class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.47.0",
      revision: "73da2d373f064b96297f9504b5b0755ad0307ef6"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "744c7f31630ba9a668a2607074045bd8abf2aeb71de1319469ef4a1990679d4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3046c61bf581d9570d44dc00dfeb18c7788c59364323de5e8f32d7f1ed160c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4710f007f95fd1105f35d0cd1ee381aa2a39115332a6527ef646b11e43d8531"
    sha256 cellar: :any_skip_relocation, ventura:        "6f590f7b3294a00ab8e601496ad56498119f4fb0bdfd0143fdda4ba6efe16bb1"
    sha256 cellar: :any_skip_relocation, monterey:       "c35efcf94402369ca3f3210c94f07ec07e33d473b10e14dd25f91ff1a43f071c"
    sha256 cellar: :any_skip_relocation, big_sur:        "61a4c9bff7ab55cefe3df4fdeebb9f330ac3393a03dcf9b1da8cf3b5a40ec03f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b8708bb2874bb3757f82ee4be2ab7bfc194921ec8769f7eb32674b4724935e4"
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
