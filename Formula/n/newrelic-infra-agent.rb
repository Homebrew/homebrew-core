class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.74.4",
      revision: "96b29cfbb1136079ed1243329d57e4498f4e1214"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d8ed25eaa476eb27662dc36002ab6484da4d579f155e6ae60cd8cbcad2f924a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0c73f1ecdeb8184536c3b7571e018172239f0c8a84600aa7170fac8040da737"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdca78f44c330be987460ad86a1c800bca05cee5c5ab9d31b4154390dfdd2bfe"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2a474e64bb37b2090ba8d2cc7867dcf664ce5276886220022a9a1dcae58b94f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a1175994c70bb572b2825ba65240bbd1695a93b68411f96de722e92e1d032ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da03882e94154518e8ecbd04f283395d9ae19e598cb7c4720c2ce441196b8883"
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
