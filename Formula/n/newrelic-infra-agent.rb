class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.51.0",
      revision: "ba5bbe5fab336fb15e326dd6d5328b253d9d140a"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "008d4c244734c21f7f8008e52306bed01c70f4c1e6364dad3da43c96a4aaf118"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b83dd3006739a953ff5b19d01cb67ac5a1eb3a1df1ac8b311d88162fe2fdc2c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7166f7238e02995b70ba65ce8f3e407c257441aa4a92205a4f557ed9e50c7e56"
    sha256 cellar: :any_skip_relocation, sonoma:         "06f77a0bdb9395e0e37f94f043990100769bf87329cbde166527f448f29e892d"
    sha256 cellar: :any_skip_relocation, ventura:        "deff385cb6f26b09c1ae0bebacee81154106871c0266894cb0a44f6613249d27"
    sha256 cellar: :any_skip_relocation, monterey:       "a10dff6c15e9b0886342e4c45c85741c5258bedaad5381d9563fa371d6dc9057"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ae077fe52553aa4004a78e71e04db72e1981a26eced5d9891ad5cb63c8e01ef"
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
