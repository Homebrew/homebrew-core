class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.79.0",
      revision: "d32b2ff13c9bedc336c3a30c172650f5d990fad6"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65d70bdbbc4e44bd5b6fb19a8a2ed1d8e03840e60e7606141cf9056fe12d5a4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e82d46e7af8430ab5799474248881f226b58989b434081f7e32cfb936aea3b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1fc6b99be0e34097d00f00954149b0b692cc938fe8bcdc1ef543ab66d637d79"
    sha256 cellar: :any_skip_relocation, sonoma:        "059175843c926be7dda460d9b5c4fcabbfe12e24140712f1abec4d515daf762b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb68b63533f153cf4f7435ba501bac3529e85a3c0540d5782ad749d4ec3f8eef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94072f33a0027d28a046388cae5d807a0457636fe91d2947a74104b1c04ed920"
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
