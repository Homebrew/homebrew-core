class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.33.1",
      revision: "0153b920c64c428cca0ad4176930730c1b6a0e8e"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae33a08a507ec8ed8b132f30f4b6d425e55ab84279bca39d52996cf883eacffa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3eaebd3a72418e9cf9f7ae1abafc7bc53c42d6e8164d4a53d9f2ff303bd9568"
    sha256 cellar: :any_skip_relocation, monterey:       "283dc677a29979b4dacdbff3646428c15a61109b13d543ceeb861579370de3f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc297b092e82e35d08726a2356a51909b562a324f7bab78c5cd4f5a98fe75e31"
    sha256 cellar: :any_skip_relocation, catalina:       "14a15b68ae8be484efc938a78ae2589e4e848a426a1ed379a7c17e507f859d17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b831333e709eaa74f45c2530e168cff88484a610f03a8badff743e64a0d401ba"
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
