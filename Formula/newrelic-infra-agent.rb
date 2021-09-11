class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.20.2",
      revision: "d30d434995dc539e38ab84f8324f1a07d0f552ff"
  license "Apache-2.0"
  revision 1
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "e2cc3d32941798e5f4dd0e8aad7f50214ba4b6863e863cb210d973b028977ae7"
    sha256 cellar: :any_skip_relocation, catalina:     "ed5d80ba8cef45ccd7b3ac75fef36642c08c9e2ec56c09f08fddb09109f0623c"
    sha256 cellar: :any_skip_relocation, mojave:       "567ac22418bafde0e9908aeb52ba66477b9e2f58982e466d283c3685a357d2f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "688145f81ded66d1e52023e9e94ea745c138237bfca5156f7f0377900cb28396"
  end

  # https://github.com/newrelic/infrastructure-agent/issues/723
  depends_on "go@1.16" => :build
  # https://github.com/newrelic/infrastructure-agent/issues/695
  depends_on arch: :x86_64

  def install
    goarch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase
    ENV["VERSION"] = version.to_s
    ENV["GOOS"] = os
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

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
