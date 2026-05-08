class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.74.3",
      revision: "1a5edd0a85694e5ffc957389bb6a489c00dfd0eb"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8f7446cb072e8a6c3e042b39d18a14693d8ec650814ada975f85654976ea996"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b30e18d9fbf677ae0af4349ae0bd896337a1a33996ec2b39058ba21271cfaa28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b38b533ae60bba627cb1815e2779cd9924484a761dc98cb2466715ba9c49a6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b36332b3e10a8251bb9dbfcd565c7e89d037e6569589dc579f1a11972a82012"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "144f354f5255c195320e6334522a6966902cae8e3e833ea227581b189eccc95c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9cb6b98ed179105a4cd400a39c042557268381a30c92aee358b80734abb0e11"
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
