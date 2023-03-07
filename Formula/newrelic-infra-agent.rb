class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.38.0",
      revision: "5f1d8b89949237f24469b5d46f4dbb4f34ea7ac7"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2c8cd604ad09a61a9b9d4f819d9a7595f5e166a537370755838fa08c701491d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df076775a1fc442593ba39c12383568d512ca5c6c15dd8d4d8c9e00550eef1b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e44a64c5a902885a990e9de3451bdb3a6335026f25005623e95031aa981fb06"
    sha256 cellar: :any_skip_relocation, ventura:        "992189031e12866150e4e9634434285afd16f1bd4dc960a8da17172cb967a9bc"
    sha256 cellar: :any_skip_relocation, monterey:       "885cdf6c2ee682bff95ecc61971bf2c81253fd1c9977b1d68ebcc09c9b73adc3"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ceec5943d8a3fa4a68023ac70b68f6510727a8ec154df165441417ee96681aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3204c54af005e1e3ac99dc113affddac567fc3fca95f5235b451c7b8e794db7e"
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
