class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.39.1",
      revision: "5051b41d1fa18535e76f03943f24d254e089f223"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ffa06f3f476b6974f03ab74911935eb9a0174b03efdd1aa4c9daa4f4c42f631"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8178672c14e0d706cad5bf2ba900995a7be9def3991918676ecd69caef665bb4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c8f6a7980f1b64c3ae409321cbd2451cb44b874bf58a42c91b7a2560561ad77"
    sha256 cellar: :any_skip_relocation, ventura:        "2577406449eb9ab2b43f849f0f31fe9f3cbba83bb71f538186be1e229ef89563"
    sha256 cellar: :any_skip_relocation, monterey:       "6bafc900bdadb87b0ecca6d33c37b9986ec0a0e968dcb87c3a72f32d5294dec5"
    sha256 cellar: :any_skip_relocation, big_sur:        "7cfc4c0726530b177566b1104f577092efa24bc14bdd1721e6b14d0b7e1a424d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1157d4503ebfad5056f98779be2d242b05bcbed5d2a6e1a2b60ddbbcc22911c4"
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
