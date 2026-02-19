class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.72.4",
      revision: "488cdce6724ebb5cd58e9edcc31ec7d0285ff9c4"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7f6af321497776a40805840aa52a94bbb58d1e5742c037d4084863047e67135"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e88421ab8ade5c3ebe76471188c7fcc67d16b7831757d9c2b43ec0b473d1cca5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f65377827567448d4a40a98269ffee70fc442d5d69124dbad69dc47e1c1e2616"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac6804e9716196f6a39b31101c106290694733479f30ad8a2a56c49bf098c877"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aad606a6f8b1dbc7f0553b00a7d72f915afa882b129a547e2439eb3662c729fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bde762780e201cf6e9eab2f49c309104b3265c5bc2c497061ce600a484f30d75"
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
