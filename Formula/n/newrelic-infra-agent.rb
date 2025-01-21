class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.60.1",
      revision: "6172dfe5971bd2729d7a28b8b52830929c3023d5"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79b57397c0a5405aadf2e4741cfd26b6be07ac606375c03240d636036a105ccf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1ad70e4d141a8b12f53bc65177edb6c1aecbd154137c9de7f647a840f03b42d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b48fbbe6dfc0a892cec2567e54b796eb47fd7752accae031f3b59b69361897f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6284d5b5267ad1ca6f2c635af9e215f7ec695e2ecfefbc1fdc049efd9072e8c"
    sha256 cellar: :any_skip_relocation, ventura:       "207e2b3981b1d76e994bdd227e8661acf45f1bf972b52f8044628e3b9788a613"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2772b90465b0611045c0f1cb711c64bbc875cbf3f8c6fd1f3292902274a93130"
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
