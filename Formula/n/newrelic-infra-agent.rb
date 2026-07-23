class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.78.1",
      revision: "ce15da1ca790254f77a677b84bbf9f9bf3eb1b89"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f89bccfdf2e3e060b669fd064cd10c8add4a1f97e60ef4ecaa5909b59bff854f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91845a221b46fce4cdad48388b51871bf7e0c75f8547f7796706fd44ca8016fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7195fdbaf597a8b3c9b3b0d3f8b5b3a201c8d7976299e0325aad12db7a28227a"
    sha256 cellar: :any_skip_relocation, sonoma:        "31c0b1ce4e4ced4402a8f2d5dae044f93ce6d1db9e4861b80b81184991f697d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09e87951f7e6affd6b209276d0fa8dae19e8cb21c46b05c5706315b94d12963e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b23e44ffbdc2d71268398370fb39a94c7a28f8eba529b8d764fcd3587c8b09a"
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
