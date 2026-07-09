class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.77.1",
      revision: "3d6d75195818f934e68d075c3bef5879cdcf5dff"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a57047713fafe6371bdce1cf0632a13b14fe50184f31d682e8faf32072a60352"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33abe81e973a6ee5fb05857096c1953e0d9cf0f948bdc15c068e8b78be054a39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6632521cffbe43769d41d771f9a37dffc2350f3b97b979b108af740ee3fc93d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9da876265a0817af3b822de39e5cc7b14f5a9468cc9b4743fcd6c3908b59d9d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57ea690ce9b40a7185a2f91af20cfd6bd99effe3291e40d91e24bf67490056cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be96cda10edee1c6aee66a1c61fdc5a5a35f8a8cac2eeb7a7d1008acb3f2b3f2"
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
    (etc/"newrelic-infra").mkpath
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
