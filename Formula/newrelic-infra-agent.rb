class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.41.0",
      revision: "c7affda7b8b70cdf119e3f726f2add5680b1b160"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60f101f0c784cb7d78fcb272d817c211ca7334c58e41feac0f4d0daf6abe5e4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "783f785503614d80a04147ffbd431bc5261046c318b6fe681624ee0a46bdefb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f09ad8d994d5acdc7241548c9fb6c0984fb85970bea8beeeeb34b305c270317"
    sha256 cellar: :any_skip_relocation, ventura:        "4a3f9b1e048c05a65edf3ace7d3559453d0545e6778fccf1bd5a90979b070c04"
    sha256 cellar: :any_skip_relocation, monterey:       "a5fb73d730c6d95223c6445380adf5674e3a501c3a9878a4195fe099618a5105"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfce035076129c03be2f994ccf27634e10fd6f542cfc29e417e7dce878ab28e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85acf2932aaab376bc49386920edc8ad1b9fa6af4935e6498f5bc1e6fac86331"
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
