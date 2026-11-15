class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "2.0.2",
      revision: "acae469489d1da401fa5466631f451bcf716dc5e"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b61013efcb6dcbc5d0737cf7881f10c5a041463d2ec193c6c0640751295e4735"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0c989ab75a0e26620881a4ee33a6612ae2de9eff34582a50e2b8119b08df4fc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5b1f60bc5b628f3d0fbb8a87e6cfc6cf9975a48b77c4b491a8fb66040859f223"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e54d87ab12a76fc11f18452233cc98f93de3df83e4567d28f36ad79b30eae12a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1d9ad9f033ab9ac78d999420f36af1ba8705c69cc70f00430bd0d4bc160e7442"
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
