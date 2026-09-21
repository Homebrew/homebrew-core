class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.80.4",
      revision: "5afd0ad46b0257caa5aac1cf1e9c32c9c6e2a5c0"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c66065608169d7383bace35ceb7f698c518f77c847b7b63e0584fc294a3b6b4d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ce7a8f50503fbf62737ae6d3f8b6f7649e6598c6c044b6b97cb7ec61eeeabd89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6b2ab506a9afeb3640254552b84f6ddd80c8ae19ce415a6c89ec1174de1e779e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b5498aea3288a0548ff72be4800b9dbdf780f29d12dda9ba05e061ea2d777517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "abe96977ecbae98a36237b1cd1ac8ca6a0306d2352edf0443c8809333ffb312f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
