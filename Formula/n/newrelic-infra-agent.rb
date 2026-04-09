class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.73.0",
      revision: "81c76f2b49e6d6a474971ffc2bb5a96b3956fa3b"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e20f2f5faf60b06910f6d906d68429fa9c5bca95378d866eb5b83077ad6847a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "373a8b7b05a98a4e37931be46a79973da307660e5ae2df3219512107d8205747"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29051b45ede076359b3744efccc7e5747d532c8680a2395d48ce1923ec486904"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f78b44574add9fa8d52ffa6b21e76f607155a558504478c6542b63b253c6eee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca41021d69c61224a598211d253b960961b093fbcfdea572d5035a1d11bf0639"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16460d8d471d44c0c89cc8093d0eb3c79cffe780069d9c352390da8c5685a435"
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
