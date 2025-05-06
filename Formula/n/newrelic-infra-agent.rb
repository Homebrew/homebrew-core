class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.63.1",
      revision: "440f5b7726fec45a7b0380b4a385959039bc505f"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92e23fd0e56dd3418a9e0c8cb10cbe68e2a818ec4eef8d6c7352d6d8affc6122"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "498dd89ebc822d621c785aef5a71697f441258991fc4febcdf292669afdde98e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15f370f9939a6ad4cd83f5f735c869d85ce7ed856f260b41960e798578342b30"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7f2a50f4529a2a01f6118fa79558c896753daedde7fae4d823e06bffd54f288"
    sha256 cellar: :any_skip_relocation, ventura:       "7dc6c1dcbfb61296fd12840af4c5118d3c9876369580fe732d71b7018c123c42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31da91cd110a6805675b9b89f7561a5f2c60c9c39383dbf9f9c1e98d8a56d6c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c216630ff1a21844c9c9dbfcd6b29105ca2f40b1d07b405ad424b8ba230b7c54"
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
