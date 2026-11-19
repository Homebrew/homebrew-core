class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "2.1.1",
      revision: "19c10426ee1c14463a6507460ec608718a179cbe"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fda41e419296cf34933f7dc3500393e23720eb605d943b6cc095700b15c0a375"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b9ed26b49efc373c8e4539c437a30c7689640f2101b3fe067c9984892412918f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "65928decb0fb5ed47ea3bc46680b45bcb75ec2975e71403290ba31547e3ac209"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e549931f7f2b3a9305f3b86c8ddd7708c852e6a25118deb9b7b40854eb0187a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "cd6db14864b4c46c684712614d650e9a80dafb0b96dc31f461a438d81c83637f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
