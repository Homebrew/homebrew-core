class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.56.1",
      revision: "0f3c666ec210c01004eac33df2bf51530b1b6a4c"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6794377e0c0a0caa8542d07ff2ebd87e9f13413df83060909dcadfafc6b6d3b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "204411fc3cc292632f75e8cb6182315e3fd93c626b59812c2bf4e639636317da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c2d48a57d9e44403e4674c49089313bf51ac2077f3948868114f05b3be07d99"
    sha256 cellar: :any_skip_relocation, sonoma:         "97021f2548de614e3a8784189b6ef6d1487caaace5849c792eb30edaf52e7a3f"
    sha256 cellar: :any_skip_relocation, ventura:        "62e68241d856246a2aadccaef46fb53d910f79910997d6ac6192e25dac590cf5"
    sha256 cellar: :any_skip_relocation, monterey:       "afd3fb075d54455090b0bd1dadeaba6c37430c5403dec29d857bb9017ccbd8d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ec3c4171d7a50f8878f25a59578a47c640fb61a665e55dbebcf4be905d093e8"
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
