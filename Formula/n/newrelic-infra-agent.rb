class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.74.1",
      revision: "f3aa3aa100107345255e547b333509043700f7bd"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f59a2431a8adf51f58ccbc54c9c9dd0f2bcdb36aee701e3934d32702fff64b28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da5ce58facea0fb583041b1426aeb951dc6a2612c1ee559e62a81c5ccf981267"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f691c00360f3313bdc7651eb23c5d740a07382397b2040a2585e9e32dd851848"
    sha256 cellar: :any_skip_relocation, sonoma:        "80353af2ac63e2607b47f6bee96de80253f29d95018a05e42cb5d7c4766fa457"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ca7680710aec1391d3ccdb10847cd7f680bc546ec8ba7c1e76f92b474eda031"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cb1a0346796b8a2304307d83419c003bff64eec40bfa3242b3347ff19fc0f36"
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
