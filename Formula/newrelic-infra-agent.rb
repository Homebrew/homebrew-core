class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.35.0",
      revision: "6dc7acdd4768f7e9aa0c5cc04a636bce9e2344e2"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "888022511b235db90afd51b6b2bec703af284a1291c179e171a76072cca4d683"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89c2f8bfd8f6e550a8b4b4391431bbaa33903688b3435e7b8a83bcbe3604c891"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64e6d62a70e023e97cbdb864f8ab426861a99d98e30b85f9ebdb2100f96b568a"
    sha256 cellar: :any_skip_relocation, ventura:        "41b8e660d065c1d18aecf7060a1dbadab701cbada4a09c29bf5fa083e03fd623"
    sha256 cellar: :any_skip_relocation, monterey:       "40cae0c145458cdf25b6324f515adc5bd507f52c79ce562fd44fef57da2879cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "453b7d8ad65db2af55de027c412509bd375f5188a5bda47efae29d8db8e6f1a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37c3b4a2a02dfd12e2b70d08cb69311415812696d8be4c90f0ca6a8dbb04e7ea"
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
