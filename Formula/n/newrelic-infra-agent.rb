class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.47.1",
      revision: "a42687da1980cee7d153a86e415871d38e330c68"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35d8f42d1e637e5443c9ec94059d05072d7ada749c003d8e4545059ac7aed9a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65f771f500412dac0f86ddd9a17a0bc246567d4954d93dbd3afaccc1cc597d56"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3bbb3057054f6450b96adb8098f7e970388185d234a284ec4ad0fd3234ff9cd"
    sha256 cellar: :any_skip_relocation, ventura:        "48ab6d942876baa3288edfe93cfa91cf052f3efe8cf4fdb7e6f00ead5f054757"
    sha256 cellar: :any_skip_relocation, monterey:       "e9c45bec807d242f3d6573d3e630fe85110b93468eb3feeced2cede6b8b36d38"
    sha256 cellar: :any_skip_relocation, big_sur:        "a65a360d72a2a2126c5fd72a2380fb9a0452edba087c444edf42bdb0e101586c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f44aebfdc991a354ecc2862e52be7cea9eae727b5d90823fde2c0808276e518d"
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
