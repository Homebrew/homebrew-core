class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.20.7",
      revision: "b17a417d4745da7be9c00ecc72619523867f7add"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "ffdb274016361a220fbc8fb21cfae1b90347c03ff7c86e128d20a6c3a0a6053b"
    sha256 cellar: :any_skip_relocation, big_sur:      "bf1f38cc2c2f73370f92c7645eb9c228dbaf5f760b700477f1c40e7de34690b7"
    sha256 cellar: :any_skip_relocation, catalina:     "966da6a25822e35c9e96e518336b3d1bb3ceb9e06c88d9456c19e2305ab45570"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "93328d150756320c4ea4a9aba6c66dd773cdc1b7c63db1165918f64ca8409194"
  end

  # https://github.com/newrelic/infrastructure-agent/issues/723
  depends_on "go@1.16" => :build
  # https://github.com/newrelic/infrastructure-agent/issues/695
  depends_on arch: :x86_64

  def install
    goarch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase
    ENV["VERSION"] = version.to_s
    ENV["GOOS"] = os
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

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
