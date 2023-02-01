class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.37.1",
      revision: "d2755a8da4c943e6833ca0a3be9918c050e1c31a"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "035619656ec3698fa5841373c3cd0277503328926a0aa8d11e9ad4bbe37aa3a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "222a252a681476854109bfdf115cb7a2cd6099c1bb1cb5bb5c9a62f2dcd54bb7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe6ddcd8137d4aa1adad8cb29c8deb08ea834dc2d35afd862d55868ccf1ea686"
    sha256 cellar: :any_skip_relocation, ventura:        "72f36f16f67c2f16d6bb9ac2734087bb9ce7af7080afef2c6d01a7cf827c2620"
    sha256 cellar: :any_skip_relocation, monterey:       "9bf669b3dcef88e97dde1a3c44bc123d91cb72618c114dd27087408742816d21"
    sha256 cellar: :any_skip_relocation, big_sur:        "7836bafc06bc23ae746914797aa328b5ba5741798db69f323c7ae79fa42490c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6064956b84fe7c119a5737c8a54d2a57d85f030b503868e167fc321f3990ee51"
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
