class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.42.4",
      revision: "af493a9f799f40467e51feeb9cecbefc943650ac"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ca1e6922a8c967ca390c186bf92d47cc1aaea026f238e058a57d138bf30e7bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "661d3dc297deb0768f9b7dc0181f23935a702ecb8fced7547214a6f8d205b540"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68b70cd0a59461592f324fd628941ad6921e002cedeb85b4ccd24f1eb6a06dbf"
    sha256 cellar: :any_skip_relocation, ventura:        "ce7353ca2f10a650ef4aa1b520b189f52416c899cc5e3df7f32f7d906633c45a"
    sha256 cellar: :any_skip_relocation, monterey:       "ca7a48f99659737497f43d961b185483659ccd4114bc4b73bc73500bbff872c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e0b110facb15d2afeefde23addd5c950af8666a453c813ca34b4a2d09d0d208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "255ffe0c0d9da1de4bda867a2fe70e28b76b34ecec4f2d5b9c9e0bfe5fcd3a1d"
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
