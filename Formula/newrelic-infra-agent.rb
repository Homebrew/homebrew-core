class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.39.1",
      revision: "5051b41d1fa18535e76f03943f24d254e089f223"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01cf96f1bc17d9f04aa74bffb0f41e440f721180aabf57a6440f77fd222cebdd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbe48c0ccdd91995490e019c9d5e5b98beda9939920e26c897a707892a57b841"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e568af32c012cd3aeaa171b36b998743796cc2e0f39ded6268ffd7974bb93f9"
    sha256 cellar: :any_skip_relocation, ventura:        "d72ffe6fe5d9cc93fa5f1c286920aefe7b7833d2896223cd4a26f8c587a28767"
    sha256 cellar: :any_skip_relocation, monterey:       "a57838e78c21278d92065a2b51f73ff036cf8c381e04515d1c8a700ba3460752"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd50de82d27cb8ed25afaf201e94138df9f2d6a191dec1b1a27dc38510a20878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3813e58ae7b531e2eb89e2fe483e21e35ff5b83e95c714d8cb08106f6851c20"
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
