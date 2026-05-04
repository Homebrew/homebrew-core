class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.74.2",
      revision: "fc054805a06d651677ef66421f6d2f0137dfa03e"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18726ca8a33096b2b8a4ba0df9b621838f1e33171f41e0ac9cad7e499b2cc766"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e03dfa780ac0f803ce885efbd8c196560873b9c073003cdff12a281d3ef7f422"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbd5ef2153d29c1c7a012ad071a6b86ddd2821d8b199162b7b25f43b3502186c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1f5e75faf757e3d98bb88988cdd2018e6fa9ee277a55403df67b5a1ca81e82f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6d67737f79e8c61cf071960f219bda66c00ce4ae9dd9c6920fa9badb7e6986d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "925c5bd36b2aef7e30d323f9f955057c4d0e1f98c37ef35f482af2ed7ae2135b"
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
