class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.40.1",
      revision: "a19bf2faf96efaa6fb93ec06a20eab91e9d7bce5"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a735636c54920007b195b0a042eceec0409eef7993f49de713c24ef78f54f726"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bc040740b52f21cabef68c0042c76a6cf66031eced8ae03c74622496a3b5d61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "adce3a3fb0b5cedaca184ea4547c69c21aa4ae79b38fa3136ee1b48a6eae5764"
    sha256 cellar: :any_skip_relocation, ventura:        "2a05ca3af2f41627e4d1774f348f70d2144b476489a74f81a7b06e04976d55b2"
    sha256 cellar: :any_skip_relocation, monterey:       "b9ba390810a158b8fc77160aa53026a9910a3f0abd26f94c2fce06b4c9cdce70"
    sha256 cellar: :any_skip_relocation, big_sur:        "3dc822c801dce21111693a2f98ed950cc6204d09a5820bbf44862329f9580c5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70d226ab243283c3c98eec2630e331a1245e43344021012e9b595e38645a54b8"
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
