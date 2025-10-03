class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.69.0",
      revision: "c0d0eeaf5be332ed9c3895fd3e1813b0ae831af1"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4739f6bf4d0178e92cf2fa3e8cfa1035c46e58fe152278832d22dddb66ece615"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d45399b9691a8ca0c2d38ee6cb7b1ee40cf051e1843dae44c3652298c52a2dcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7053c54ec7febd762747951c51d388e86f0b534602d0a69ef829cbcc2540c309"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd21ab4c027763dc0338b79250d8742d15ac4a3b2e1e701c14053f2691e21354"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e246ceab98d994dd7b0d9ce25518b2dc91840b59056cfda5e96a3d61f8ecb562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "069923065671f7a510089efdcbf16335e8aecab816c9d5c95f8a601c3e5bfc82"
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
