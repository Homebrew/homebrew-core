class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.80.0",
      revision: "c00900385f98d2e4134f56f4d0d830e40b8c6ccb"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "337151aefe862ab6e8699665e6b3186c15985feca98a01276a91c855e4bb8b98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb96a5fa7e47abb3df528c96068975c201e89fc7bc901ca51db559b0475e1d2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5cef2a80917ba790e34d0d93bab62c437d59b8329c44f0e2020ee33a9cf23a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c035db821caf8359cba10e73f31df3a4ce289a6a801d4b7bf7c6bcb3cad5189"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9ce07d80a8e47d910aada469ed534c70903aecc5e228ea6c3b9d177e0e90a93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d01412505b7a1a28f5bbeaa5880d556b885a923cdfb333b106b9c63df645bb05"
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
