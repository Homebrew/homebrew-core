class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.31.0",
      revision: "f90a2d1397ae7f8d69ad46dd4d6be425b4af3830"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7d98172441d157e4e441c4f8779571d46efd660b5c06eb8405966f5e37e2a83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8d5f5a8e875729d7d6213196895ebe9f5cf66236cefcf4f1fb9545bc8365397"
    sha256 cellar: :any_skip_relocation, monterey:       "6bed08489d16dc0430b5975a38d2d37dc7c3ccbc66286f85f17e015ffcb53cd1"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef0a4dea3d6d2c9889fc327aad60f936cbb1e92aa826fa2643667ae81ccb98c7"
    sha256 cellar: :any_skip_relocation, catalina:       "f1de94c5478d03b9a18a924ad6a44d5c5725e847cf12f1a2237440a8e27c0dd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e3e43ee4e4eae348bbd3b86e1fb885c935c7dd1f679c6de98bbcbe9e459567d"
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
